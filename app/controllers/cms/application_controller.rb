class Cms::ApplicationController < ApplicationController
  before_action :check_if_valid_user_login

  def check_if_valid_user_login
    # it would be improve in future
    if controller_name != 'sessions'
      redirect_to cms_root_url if current_user.blank? || (current_user.user_type != 'admin' && current_user.user_type != 'employee')
    end
  end
end
