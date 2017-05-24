class Cms::UsersController < Cms::ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "New user was created"
      redirect_to cms_users_path
    else
      @id = user_params[:type_id]
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(user_params[:id])
    if @user.update_attributes(user_params)
      redirect_to cms_users_path(id: @user.id)
      flash[:success] = "Update success"
    else
      render :new
      flash[:error] = "update fail"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.includes(:employee).all
  end

  def destroy
    @user = User.find(params[:id])
    @user.delete
    redirect_to cms_users_path
  end

  def update_avatar
    user = User.find(params[:id])
    user.update_attribute(:user_icon, params.permit(:image))
    redirect_to cms_user_path(user.id)
  end

  def changepassword
    user = User.find(params[:id])
    if user.password == change_password_params[:current_password]
      if change_password_params[:password] == change_password_params[:password_confirmation]
        user.update_attribute(:password, change_password_params[:password])
      else
        flash[:fails] = "password confirm is not exact"
      end
    else
      flash[:fails] = "current password is not exact"
    end
    redirect_to cms_user_path(user.id)
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :user_type, :type_id)
    end

    def change_password_params
      params.permit(:current_password, :password, :password_confirmation)
    end

end
