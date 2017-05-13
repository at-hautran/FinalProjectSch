class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.integer :phonenumber
      t.string :email
      t.string :gender
      t.date :bithday
      t.string :position

      t.timestamps
    end
  end
end
