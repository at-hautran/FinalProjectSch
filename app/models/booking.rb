class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :room
  belongs_to :user

  validate :check_check_out_greater_than_check_in
  validate :check_plan_present

  has_secure_password

  def check_check_out_greater_than_check_in
    return if check_out.blank? || check_in.blank?
    if check_out < check_in
      errors.add(:check_in, "can not greater than check out")
    end
  end

  def check_plan_present
    errors.add(:check_in, "must be set") if check_in.blank?
    errors.add(:check_out, "must be set") if check_out.blank?
  end
end