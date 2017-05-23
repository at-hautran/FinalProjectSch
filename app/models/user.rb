class User < ApplicationRecord
  self.table_name = 'users'
  has_one :employee, foreign_key: :type_id
  has_many :top_images
  has_many :bookings
  has_many :rooms
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :password, presence: true
  validates :type_id, presence: true
  validates :user_type, presence: true
  # validates_uniqueness_of :type_id
end