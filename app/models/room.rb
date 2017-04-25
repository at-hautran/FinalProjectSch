class Room < ApplicationRecord
  validates :room_icon, presence: true
  validates :price, presence: true
  has_many :bookings
  mount_uploader :room_icon, RoomIconUploader
  serialize :room_icon, JSON
end
