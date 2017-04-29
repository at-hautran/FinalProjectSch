class User < ApplicationRecord
  self.table_name = 'users'
  has_many :bookings
end
