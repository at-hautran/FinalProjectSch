class Customer < ApplicationRecord
  has_many :bookings
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validate :valid_country

    def valid_country
      errors.add(:country, "Country is invalid") unless Country[country]
    end
end
