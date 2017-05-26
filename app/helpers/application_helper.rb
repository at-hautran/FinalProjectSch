module ApplicationHelper

  BOOKING_STATUS = %w[status waitting accepted are_using finished]
  def init_session user
    session[:id] = user.id
  end

  def current_user
    User.find_by(id: session[:id])
  end

  def current_user_type
    Employee.find(current_user.type_id) if current_user.present? && current_user.type_id.present?
  end

  def determine user_id
    user = User.find(user_id)
    if user.user_type == 'Admin'
      Admin.find(user.type_id)
    elsif user.user_type == 'Employee'
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
