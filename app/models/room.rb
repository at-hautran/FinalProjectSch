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

  def self.get_empty_room(check_in, check_out, using_room_ids=-1)
    using_room_ids = self.get_using_room(check_in, check_out).uniq.pluck(:id) || -1
    self.where.not(id: using_room_ids)
  end

  def self.get_using_room(check_in, check_out)
    statement_check_room_cannot_use = "(check_in <= ? AND check_out >= ?)
                                    OR (check_in <= ? AND check_out >= ?)
                                    OR (check_in >= ? AND check_out <= ?)"
    room_cannot_use_santitize = sanitize_sql_for_conditions([statement_check_room_cannot_use,
                                 check_in, check_in,
                                 check_out, check_out,
                                 check_in, check_out])
    Booking.where(room_cannot_use_santitize).pluck(:room_id).uniq || -1
  end
end
