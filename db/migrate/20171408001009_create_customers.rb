class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.integer :phonenumber
      t.string :street
      t.integer :number_street
      t.string :city
      t.string :postcode
      t.string :country

      t.timestamps
    end
  end
end
