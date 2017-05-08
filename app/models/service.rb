class Service < ApplicationRecord
  mount_uploader :service_icon, RoomIconUploader
  belongs_to :booking_service
end
