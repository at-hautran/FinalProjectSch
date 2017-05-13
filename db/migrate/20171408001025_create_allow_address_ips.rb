class CreateAllowAddressIps < ActiveRecord::Migration[5.0]
  def change
    create_table :allow_address_ips do |t|
      t.string :ip_address

      t.timestamps
    end
  end
end
