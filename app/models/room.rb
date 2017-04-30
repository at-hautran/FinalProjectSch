class Room < ApplicationRecord
  audited
  # validates :room_icon, presence: true
  validates :price, presence: true
  has_many :bookings

  mount_uploader :room_icon, RoomIconUploader
  serialize :room_icon, JSON

  def self.incremental_search(rooms)
    rooms.pluck(:id, :name).map do |room|
      { value: "#{room[0]}#{room[1]}", data: room[0] }
    end
  end
end
