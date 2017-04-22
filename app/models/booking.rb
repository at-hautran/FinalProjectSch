class Booking < ApplicationRecord
  belong_to :customer
  belong_to :room
end
