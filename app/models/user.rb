class User < ApplicationRecord
  self.table_name = 'users'
  has_many :top_images
  has_many :bookings
  has_many :rooms
end