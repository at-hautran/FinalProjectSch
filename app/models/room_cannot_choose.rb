class RoomCannotChoose < ApplicationRecord
  validates :room_id, presence: true
  validates :from_date, presence: true
  validates_numericality_of :room_id

  # check room is not allow in cms
  def self.select_room_cannot_choose(from_date, to_date)
    sql = <<-SQL
      SELECT room_id
      FROM room_cannot_chooses
      WHERE (STRFTIME('%Y-%m-%d', from_date) <= ? AND STRFTIME('%Y-%m-%d', to_date) >= ?)
            OR (STRFTIME('%Y-%m-%d', from_date) <= ? AND STRFTIME('%Y-%m-%d', to_date) >= ?)
            OR (STRFTIME('%Y-%m-%d', from_date) >= ? AND STRFTIME('%Y-%m-%d', to_date) <= ?)
            OR (STRFTIME('%Y-%m-%d', from_date) <= ? AND STRFTIME('%Y-%m-%d', to_date) >= ? AND to_date IS NULL)
    SQL
    santitize_sql = sanitize_sql_for_conditions([sql,
                                                from_date.to_date, from_date.to_date,
                                                to_date.to_date, to_date.to_date,
                                                from_date.to_date, to_date.to_date,
                                                from_date.to_date, from_date.to_date])
    self.find_by_sql(santitize_sql).map {|room| room.room_id}
  end

  def self.check_valid_params room_id
    errors = {}
    errors[room_id] = "Room #{room_id} is not exsit" if Room.find_by(id: room_id).blank?
    errors
  end
end
