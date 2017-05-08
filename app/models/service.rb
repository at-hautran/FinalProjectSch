class Service < ApplicationRecord
  include AASM

  aasm column: :status do
    state :new, :initial => true
    state :open
    state :close

    event :open do
      transitions :from => [:new, :close], :to => :open
    end

    event :close do
      transitions :from => [:new, :open], :to => :close
    end
  end
  # validates :service_icon, presence: true
  # validates :name, presence: true
  # validates :price, presence: true, numericality: { allow_nil: false, greater_than: 0}
  # validates :status, presence: true
  mount_uploader :service_icon, ServiceIconUploader
  belongs_to :booking_service

  scope :service, ->{ where(status: 'can book') }
end
