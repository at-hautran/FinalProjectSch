class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :confirm_password
      t.datetime :birthday
      t.string :gender
      t.integer :phone_number
      t.string :address
      t.string :user_type
      t.integer :type_id

      t.timestamps
    end
  end
end
