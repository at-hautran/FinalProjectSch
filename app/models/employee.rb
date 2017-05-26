class Employee < ApplicationRecord
  has_one :user
  has_many :users, foreign_key: :type_id
end
