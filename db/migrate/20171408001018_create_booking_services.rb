class CreateBookingServices < ActiveRecord::Migration[5.0]
  def change
    create_table :booking_services do |t|
      t.integer :booking_id
      t.integer :service_id
      t.integer :number
      t.datetime :time
      t.integer :price
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
