class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.datetime :check_in
      t.datetime :check_out
      t.integer :childrens
      t.integer :adults
      t.integer :room_id
      t.string :pay
      t.boolean :pay_online, default: false
      t.string :paypal_customer_token
      t.string :paypal_payment_token
      t.integer :price
      t.integer :total_payed
      t.integer :customer_id
      t.string :comments
      t.integer :user_id

      t.timestamps
    end
  end
end
