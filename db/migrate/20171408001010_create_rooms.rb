class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :type
      t.integer :price
      t.integer :adults
      t.integer :children

      t.timestamps
    end
  end
end
