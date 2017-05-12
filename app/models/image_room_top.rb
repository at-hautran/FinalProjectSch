class ImageRoomTop < ApplicationRecord
  belongs_to :room
  def self.update_rooms top_image_params
    top_images = self.all
    top_image_params.each_with_index do |room_image, position|
      top_images[position].update_attributes room_image
    end
  end

  def self.init_record
    sum_of_records = self.count
    if sum_of_records < 3 && sum_of_records >= 0
      (sum_of_records...3).each do
        self.create()
      end
    end
    if sum_of_records > 3
      self.order(created_at: :desc).limit(sum_of_records - 4).destroy_all
    end
  end

  def self.check_valid_params params
    room_ids = params.map { |param| param[:room_id]}.reject {|room_id| room_id.blank? }.reject {|room_id| room_id.blank?}
    errors = {}
    errors[:not_enough_room_id] = "You must fill all room id" if room_ids.length < 3
    rooms = Room.where(id: room_ids)
    room_ids.each do |room_id|
      room = rooms.detect { |rm| rm.id == room_id.to_i }
      if room.nil?
        errors[room_id] = "Room id#{room_id} does not exsit"
      end
    end
    errors
  end
end
