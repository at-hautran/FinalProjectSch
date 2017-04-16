module ApplicationHelper
  def init_session user
    session[:id] = user.id
  end

  def current_user
    User.find_by(id: session[:id])
  end

  def login?
    current_user.nil? ? false : true
  end

  def logout user
    session.delete(user.id)
  end

  def requestlogin?
    current_user.nil? ? true : false
  end
end
