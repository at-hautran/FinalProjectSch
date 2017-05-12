class Cms::RoomCannotChoosesController < Cms::ApplicationController
  before_action :check_valid_params, only: :create
  def update
  end

  def create
    @room_cannot_choose = RoomCannotChoose.new room_params
    if flash[:errors].blank?
      @room_cannot_choose.save
      flash[:success] = "Create success"
      redirect_to cms_room_cannot_chooses_url
    else
      @room_cannot_chooses = RoomCannotChoose.all
      render :index
    end
  end

  def index
    @room_cannot_chooses = RoomCannotChoose.all
  end

  def destroy
    RoomCannotChoose.find(params[:id]).delete
    redirect_to cms_room_cannot_chooses_url
  end

  def destroy_all
    RoomCannotChoose.delete_all
    redirect_to cms_room_cannot_chooses_url
  end

  def check_valid_params
    flash[:errors] = RoomCannotChoose.check_valid_params(room_params[:room_id])
  end

  def room_params
    params.require(:room).permit(:room_id, :from_date, :to_date)
  end
end
