class Cms::SessionsController < Cms::ApplicationController
  def new
  end

  def create
    user = User.find_by(email: login_params[:email])
    if user.present? && user.password == login_params[:password]
      init_session(user)
      redirect_to new_cms_sessions_url
    else
      render :new
    end
  end

  def destroy
  end

  def login_params
    params.permit(:email, :password)
  end
end
