require 'csv'
class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :room
  belongs_to :user
  self.table_name = 'bookings'
  attr_accessor :remember_token, :verification_token
  before_create :create_verification_digest
  scope :booking, ->(customer_id) {where(customer_id: customer_id)}

  audited
  self.non_audited_columns = [:updated_at, :create_at, :verification_digest, :verified, :booking_no, :verified_at]
  # validate :check_check_out_greater_than_check_in
  # validate :check_plan_present

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
end