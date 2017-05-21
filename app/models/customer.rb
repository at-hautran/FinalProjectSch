class Customer < ApplicationRecord
  has_many :bookings
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
