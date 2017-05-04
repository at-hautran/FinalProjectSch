class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  include ApplicationHelper
  def authenticated_user
    if current_user
      current_user
    else
      'Non'
    end
  end
end