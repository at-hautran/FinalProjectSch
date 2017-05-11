class CreateRoomBills < ActiveRecord::Migration[5.0]
  def change
    create_table :room_bills do |t|
      t.integer :booking_id
      t.string :status

      t.timestamps
    end
  end
end
