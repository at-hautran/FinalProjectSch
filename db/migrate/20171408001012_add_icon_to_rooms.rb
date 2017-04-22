class AddIconToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :icon, :string
  end
end
