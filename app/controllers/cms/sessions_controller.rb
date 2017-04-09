class Cms::SessionsController < Cms::ApplicationController
  def new
  end

  def create
    binding.pry
    user = User.find_by(email: login_params[:email])
    if user.password == login_params[:password]
      init_sessions
      redirect_to new_cms_sessions_url
    end
  end

  def destroy
  end

  def login_params
    params.permit(:username, :password)
  end
end
