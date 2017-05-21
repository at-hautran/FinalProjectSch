class ApplicationController < ActionController::Base
  before_action :set_locale

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

  protected

  private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options
      { locale: I18n.locale }
    end

  # def extract_locale_from_accept_language_header
  #   request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  # end

    def default_url_options(options = {})
      { locale: I18n.locale }.merge options
    end
end