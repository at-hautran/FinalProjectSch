class Cms::UsersController < ApplicationController
  before_action :set_cms_user, only: [:show, :edit, :update, :destroy]

  # GET /cms/users
  # GET /cms/users.json
  def index
    @cms_users = Cms::User.all
  end

  # GET /cms/users/1
  # GET /cms/users/1.json
  def show
  end

  # GET /cms/users/new
  def new
    @cms_user = Cms::User.new
  end

  # GET /cms/users/1/edit
  def edit
  end

  # POST /cms/users
  # POST /cms/users.json
  def create
    @cms_user = Cms::User.new(cms_user_params)

    respond_to do |format|
      if @cms_user.save
        format.html { redirect_to @cms_user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @cms_user }
      else
        format.html { render :new }
        format.json { render json: @cms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/users/1
  # PATCH/PUT /cms/users/1.json
  def update
    respond_to do |format|
      if @cms_user.update(cms_user_params)
        format.html { redirect_to @cms_user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_user }
      else
        format.html { render :edit }
        format.json { render json: @cms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/users/1
  # DELETE /cms/users/1.json
  def destroy
    @cms_user.destroy
    respond_to do |format|
      format.html { redirect_to cms_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_user
      @cms_user = Cms::User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_user_params
      params.require(:cms_user).permit(:name, :email, :password, :gender, :phone_number, :address, :role, :position)
    end
end
