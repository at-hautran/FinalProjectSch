class ServiceBill < ApplicationRecord
  include AASM
  aasm :column => 'status' do
    state :unpaid, :initial => true
    state :paid

    event :paid do
      transitions :from => :unpaid, :to => :paid
    end
  end
end
