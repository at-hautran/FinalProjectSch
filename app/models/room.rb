class Room < ApplicationRecord
  has_many :booking
  mount_uploader :icon, RoomIconUploader
end
