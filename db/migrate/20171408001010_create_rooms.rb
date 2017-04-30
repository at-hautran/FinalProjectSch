class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :room_type
      t.integer :price
      t.integer :adults
      t.integer :childrens
      t.integer :user_id

      t.timestamps
    end
  end
end
