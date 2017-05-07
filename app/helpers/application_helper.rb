module ApplicationHelper

  BOOKING_STATUS = %w[waitting accepted are_using finished]
  def init_session user
    session[:id] = user.id
  end

  def current_user
    User.find_by(id: session[:id])
  end

  def login?
    current_user.nil? ? false : true
  end

  def logout
    session.delete(:id)
  end

  def requestlogin?
    current_user.nil? ? true : false
  end
end
