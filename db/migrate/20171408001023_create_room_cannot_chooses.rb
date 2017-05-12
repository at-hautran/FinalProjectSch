class CreateRoomCannotChooses < ActiveRecord::Migration[5.0]
  def change
    create_table :room_cannot_chooses do |t|
      t.integer :room_id
      t.date :from_date
      t.date :to_date

      t.timestamps
    end
  end
end
