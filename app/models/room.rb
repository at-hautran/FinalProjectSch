class Room < ApplicationRecord
  audited
  # validates :room_icon, presence: true
  validates :price, presence: true
  has_many :bookings
  has_many :image_room_tops

  mount_uploader :room_icon, RoomIconUploader
  serialize :room_icon, JSON

  def self.incremental_search(rooms)
    rooms.pluck(:id, :name).map do |room|
      { value: "#{room[0]}#{room[1]}", data: room[0] }
    end
  end

  def self.get_emptys(check_in, check_out, using_room_ids=-1)
    not_allow_room_ids = RoomCannotChoose.select_room_cannot_choose(check_in, check_out)
    using_room_ids = self.get_are_usings(check_in, check_out).pluck(:id).uniq || -1
    room_cannot_choose_ids = not_allow_room_ids + using_room_ids
    self.where.not(id: room_cannot_choose_ids)
  end

  def self.get_are_usings(check_in, check_out)
    sql = <<-SQL
      INNER JOIN (
        SELECT *
        FROM rooms
        WHERE rooms.id IN(
          SELECT distinct room_id
          FROM bookings
          WHERE  ((STRFTIME('%Y-%m-%d', check_in) <= ? AND STRFTIME('%Y-%m-%d', check_out) >= ?)
              OR (STRFTIME('%Y-%m-%d', check_in) <= ? AND STRFTIME('%Y-%m-%d', check_out) >= ?)
              OR (STRFTIME('%Y-%m-%d', check_in) >= ? AND STRFTIME('%Y-%m-%d', check_out) <= ?))
              AND (status = ? OR status = ?)
          )
        ) AS conflict_schedule_rooms
      ON rooms.id = conflict_schedule_rooms.id
    SQL
    santitize_sql = sanitize_sql_for_conditions([sql,
                                                check_in.to_date, check_in.to_date,
                                                check_out.to_date, check_out.to_date,
                                                check_in.to_date, check_out.to_date,
                                                'accepted', 'in_use'])
    Room.joins(santitize_sql)
    # statement_check_room_cannot_use = "(check_in <= ? AND check_out >= ?)
    #                                   OR (check_in <= ? AND check_out >= ?)
    #                                   OR (check_in >= ? AND check_out <= ?)"
    # room_cannot_use_santitize       = sanitize_sql_for_conditions([statement_check_room_cannot_use,
    #                                   check_in, check_in,
    #                                   check_out, check_out,
    #                                   check_in, check_out])
    # Booking.where(room_cannot_use_santitize).uniq
  end

  def self.check_schedule(room, check_in, check_out, current_booking_id=nil)
    # Check if have booking in these day
    sql = <<-SQL
      SELECT *
      FROM (
        SELECT *
        FROM bookings
        WHERE bookings.id != ? AND room_id = ?
        ) AS not_in_booking
      WHERE  ((STRFTIME('%Y-%m-%d', not_in_booking.check_in) <= ? AND STRFTIME('%Y-%m-%d', not_in_booking.check_out) >= ?)
            OR (STRFTIME('%Y-%m-%d', not_in_booking.check_in) <= ? AND STRFTIME('%Y-%m-%d', not_in_booking.check_out) >= ?)
            OR (STRFTIME('%Y-%m-%d', not_in_booking.check_in) >= ? AND STRFTIME('%Y-%m-%d', not_in_booking.check_out) <= ?))
            AND (status = ? OR status = ?)
    SQL
    santitize_sql = sanitize_sql_for_conditions([sql,
                                              current_booking_id || 0, room.id,
                                              check_in.to_date, check_in.to_date,
                                              check_out.to_date, check_out.to_date,
                                              check_in.to_date, check_out.to_date,
                                              'accepted', 'in_use'])
    booking = Booking.find_by_sql(santitize_sql).first
    if booking.present?
      errors = {}
      errors[booking.id] = "Conflict time with booking id = #{booking.id} \n
                            check_in: #{booking.check_in}, check_out: #{booking.check_out}\n"
    end
  end

  def self.check_room_is_allow(room_id, from_date, to_date)
    room_ids = RoomCannotChoose.select_room_cannot_choose(from_date, to_date)
    if room_ids.include?(room_id)
      errors = {}
      errors[:room_not_allow] = "\nThis room is not allow"
    end
  end

  def self.check_number_peoples(room, booking_adults, booking_childrens)
    errors = {}
    errors[:number_adults] = "number adults must be less than #{room.adults}\n" if room.adults < booking_adults
    errors[:number_childrens] = "number childrens must be less than #{room.childrens}\n" if room.childrens < booking_childrens
  end
end
