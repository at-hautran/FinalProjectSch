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
end
