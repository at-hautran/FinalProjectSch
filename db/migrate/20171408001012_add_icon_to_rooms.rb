class AddIconToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :avatar, :string
  end
end
