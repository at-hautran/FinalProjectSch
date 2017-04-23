class AddRoomIconToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :room_icon, :string
  end
end
