class BookingService < ApplicationRecord
  belongs_to :service
  belongs_to :booking
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
end
