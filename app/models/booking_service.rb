class BookingService < ApplicationRecord
  belongs_to :service
  belongs_to :booking
  validates :time, presence: true
  validate :check_time_must_in_future

  validate
  include AASM

  aasm :column => 'status' do
    state :watting, :initial => true
    state :booked, :cancel

    event :booked do
      transitions :from => :watting, :to => :booked
    end
    event :cancel do
      transitions :from => :watting, :to => :cancel
    end
  end

  aasm :bill, :column => 'pay'   do
    state :unpaid, :initial => true
    state :paid

    event :paid do
      transitions :from => :unpaid, :to => :paid
    end
  end

  def check_time_must_in_future
    errors.add(:time, "can not in the past") if time < (Time.zone.now + 7.hour) if time.present?
  end

  def self.paid_all(booking_id)
    self.where(booking_id: booking_id).update_all(pay: :paid)
  end
end
