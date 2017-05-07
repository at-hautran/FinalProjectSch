class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.datetime :check_in
      t.datetime :check_out
      t.integer :childrens
      t.integer :adults
      t.integer :room_id
      t.integer :customer_id
      t.integer :total_price
      t.string :comments
      t.integer :user_id

      t.timestamps
    end
  end
end
