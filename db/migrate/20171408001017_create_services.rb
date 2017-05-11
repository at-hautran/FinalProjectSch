class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :service_icon
      t.integer :price
      t.string :status

      t.timestamps
    end
  end
end
