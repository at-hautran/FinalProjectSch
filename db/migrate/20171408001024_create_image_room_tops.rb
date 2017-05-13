class CreateImageRoomTops < ActiveRecord::Migration[5.0]
  def change
    create_table :image_room_tops do |t|
      t.integer :room_id
      t.integer :image_room_top_number

      t.timestamps
    end
  end
end
