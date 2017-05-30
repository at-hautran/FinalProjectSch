class Cms::ApplicationController < ApplicationController
  before_filter :block_ip_addresses
  before_action :check_if_valid_user_login
  def check_if_valid_user_login
    # it would be improve in future
    if controller_name != 'sessions'
      redirect_to cms_root_url if current_user.blank? || (current_user.user_type != 'Admin' && current_user.user_type != 'Employee')
    end
  end

  def block_ip_addresses
    allow_ip_addresses = AllowAddressIp.pluck(:ip_address)
    head :unauthorized if allow_ip_addresses.exclude?(current_ip_address)
  end

  def current_ip_address
    request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
  end

  def check_admin
    redirect_to cms_root_path if current_user.user_type != 'Admin'
  end

  def service_prices booking
    total_prices = 0
    booking_services = BookingService.where(booking_id: booking.id, pay: :paid).where.not(status: :cancel)
    booking_services.each do |booking_service|
      total_prices = total_prices + booking_service.number*booking_service.price
    end
    total_prices
  end

  def get_date_incomes_date start_date
    dates = []
    start_date = Time.zone.now if start_date.blank?
    dates << (start_date.to_date - 2.year).strftime('%Y')
    dates << (start_date.to_date - 1.year).strftime('%Y')
    dates << start_date.to_date.strftime('%Y')
    dates
  end
end
