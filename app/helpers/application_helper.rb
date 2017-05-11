module ApplicationHelper

  BOOKING_STATUS = %w[status waitting accepted are_using finished]
  def init_session user
    session[:id] = user.id
  end

  def current_user
    User.find_by(id: session[:id])
  end

  def current_user_type
    if current_user.user_type == 'admin'
      Admin.find(current_user.type_id)
    elsif current_user.user_type = 'employee'
      Employee.find(current_user.type_id)
    end
  end

  def determine user_id
    user = User.find(user_id)
    if user.user_type == 'admin'
      Admin.find(user.type_id)
    elsif user.user_type == 'employee'
      Employee.find(user.type_id)
    end
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
