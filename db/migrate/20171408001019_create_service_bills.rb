class CreateServiceBills < ActiveRecord::Migration[5.0]
  def change
    create_table :service_bills do |t|
      t.integer :booking_service_id
      t.string :status

      t.timestamps
    end
  end
end
