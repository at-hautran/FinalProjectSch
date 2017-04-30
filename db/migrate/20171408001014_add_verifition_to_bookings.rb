class AddVerifitionToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :verification_digest, :string
    add_column :bookings, :verified, :boolean, default: false
    add_column :bookings, :booking_no, :integer
    add_column :bookings, :verified_at, :datetime
  end
end
