class Cms::SessionsController < Cms::ApplicationController
  def new
  end

  def create
    user = User.find_by(email: login_params[:email])
    if user.present? && user.password == login_params[:password]
      init_session(user)
      redirect_to cms_root_path
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to cms_root_path
  end

  def account_logout_out
    logout
    redirect_to cms_root_path
  end

  def login_params
    params.permit(:email, :password)
  end
end
