require 'csv'
class Booking < ApplicationRecord

  include AASM

  aasm :status, :column => 'status' do
    state :waitting, :initial => true
    state :cancel, :accepted, :in_use, :finished

    event :accept do
      transitions :from => :waitting, :to => :accepted
    end

    event :cancel do
      transitions :from => :accepted, :to => :cancel
    end

    event :in_use do
      transitions :from => :accepted,  :to => :in_use
    end

    event :finish do
      transitions :from => [:in_use], :to => :finished
    end
  end

  aasm :bill, :column => 'pay'   do
    state :unpaid, :initial => true
    state :paid

    event :paid do
      transitions :from => :unpaid, :to => :paid
    end
  end

  belongs_to :customer
  belongs_to :room
  belongs_to :user
  has_many :booking_service
  self.table_name = 'bookings'
  attr_accessor :remember_token, :verification_token
  before_create :create_verification_digest
  scope :booking, ->(customer_id) {where(customer_id: customer_id)}

  audited except: [:updated_at, :created_at, :verification_digest, :booking_no, :verified_at]

  self.non_audited_columns = [:updated_at, :create_at, :verification_digest, :verified, :booking_no, :verified_at]
  validate :check_check_out_greater_than_check_in
  validate :check_plan_present
  validate :time_booking_can_not_in_past

  # has_secure_password

  def check_check_out_greater_than_check_in
    return if check_out.blank? || check_in.blank?
    if check_out < check_in
      errors.add(:check_in, "can not greater than check out")
    end
  end

  def check_plan_present
    errors.add(:check_in, "must be set") if check_in.blank?
    errors.add(:check_out, "must be set") if check_out.blank?
  end

  def time_booking_can_not_in_past
    errors.add(:check_in, "must greater or equal current time") if check_in < (Time.zone.now - 1.day)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def self.to_csv(attributes = column_names, options = {})
    CSV.generate(options) do |csv|
      csv.add_row attributes
      # Iterate through all the rows.
      all.includes(:room, :customer).each do |foo|
        values = foo.attributes.merge(foo.customer.attributes).merge(foo.room.attributes).slice(*attributes).values
        csv.add_row values
      end
    end
  end

  private

  def Booking.new_token
    SecureRandom.urlsafe_base64
  end

  def Booking.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def create_verification_digest
    self.verification_token  = Booking.new_token
    self.verification_digest = Booking.digest(verification_token)
    # Create the token and digest.
  end

  def self.delete_unverifies
    Booking.where("verified IS ? AND strftime('%Y-%m-%d %H:%M:%S', created_at) <= ?", false, Time.zone.now - 1.minute).delete_all
  end

  def self.delete_expire_accept
    Booking.where("verified IS > AND strftime('%Y-%m-%d %H:%M:%S', verified_at) <= ?", true, Time.zone.now - 2.minute).delete_all
  end

  def self.search search_params, bookings
    if search_params[:email].present?
      customer_id = Customer.select(:id).find_by(email: search_params[:email])
      bookings = bookings.where(customer_id: customer_id)
    end
    if search_params[:room_name].present?
      room_id = Room.select(:id).find_by(name: search_params[:room_name])
      bookings = bookings.where(room_id: room_id)
    end
    if search_params[:status].present? && search_params[:status] != 'status'
      bookings = bookings.where(status: search_params[:status])
    end
    if search_params[:check_in].present? && search_params[:check_out].present?
      bookings = bookings.where("strftime('%Y-%m-%d', check_in) >= ? AND strftime('%Y-%m-%d', check_out) <= ? ", search_params[:check_in].to_date, search_params[:check_out].to_date)
    elsif search_params[:check_in].present? && search_params[:check_out].blank?
      bookings = bookings.where("strftime('%Y-%m-%d', check_in) = ?", search_params[:check_in].to_date.strftime('%Y-%m-%d'))
    elsif search_params[:check_in].blank? && search_params[:check_out].present?
      bookings = bookings.where("strftime('%Y-%m-%d', check_out) = ?", search_params[:check_out].to_date)
    end
    bookings
  end

  def self.save_with_paypal_payment booking, token, payer_id
    booking = Booking.find(booking.id)
    prices = (((booking.check_out - booking.check_in)/1.day).to_i + 1)*(booking.price.to_i)
    ppr = PayPal::Recurring.new(
      token: token,
      payer_id: payer_id,
      description: 'a',
      amount: prices,
      currency: 'USD'
      )
    response = ppr.request_payment
    if response.errors.present?
      raise response.errors.inspect
    else
    end
  end

  def self.save_token booking, token, payer_id
    booking.paypal_payment_token = token
    booking.paypal_customer_token = payer_id
    booking.save
  end

  def self.get_current_in_comes(start_date)
    if start_date.blank?
      start_date = Time.zone.now.strftime('%Y-%m-%d')
    end
    in_comes = self.get_finished(start_date)
  end

  def self.get_last_in_comes(start_date)
    in_comes = []
    if start_date.blank?
      start_date = Time.zone.now.strftime('%Y-%m-%d')
    end
    two_year_ago = (start_date.to_date - 2.year).strftime('%Y-%m-%d')
    in_comes << self.get_finished(two_year_ago)
    one_year_ago = (start_date.to_date - 1.year).strftime('%Y-%m-%d')
    in_comes << self.get_finished(one_year_ago)

    in_comes
  end

  def self.get_finished(start_date)
    Booking.where("(STRFTIME('%Y-%m', finished_at)) = ?", start_date.to_date.strftime('%Y-%m'))
  end

  def self.get_p_invoice booking
    customer = booking.customer
    room = booking.room
    days = ((booking.check_out.to_date - booking.check_in.to_date)/(1.day)).to_i + 1
    total_price = booking.price*days - booking.total_payed
    extra_days = total_price/booking.price
    item = InvoicePrinter::Document::Item.new(
      name: "Room#{room.name}",
      quantity: days.to_s + " days(check in from)",
      price: booking.price*85/100,
      amount: '$ ' + (total_price*85/100).to_i.to_s
    )

    invoice = InvoicePrinter::Document.new(
      number: "a",
      provider_name: 'My Hotel',
      provider_tax_id: '56565656',
      provider_tax_id2: '465454',
      provider_street: 'Cua Dai',
      provider_street_number: '1',
      provider_city: 'Hoi An',
      purchaser_name: customer.name,
      purchaser_street: customer.street,
      purchaser_street_number: customer.number_street,
      purchaser_city: customer.city,
      purchaser_postcode: customer.postcode,
      due_date: (Time.zone.now + 7.hour).strftime('%Y-%m-%d %I:%M:%S %p'),
      subtotal: (total_price*85/100).to_i,
      tax: (total_price*10/100).to_i,
      tax2: (total_price*5/100).to_i,
      total: '$ ' + total_price.to_i.to_s,
      items: [item],
      note: 'A note...'
    )
  end
end