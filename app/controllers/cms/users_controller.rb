class Cms::UsersController < Cms::ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to cms_users_path(id: @user.id)
      flash[:success] = "New user was created"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    binding.pry
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

  private

    def user_params
      params.require(:user).permit(:id, :user_name, :email, :password, :confirm, :birthday, :phone_number, :address, :role, :position)
    end

end
