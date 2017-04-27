class Cms::RoomsController < Cms::ApplicationController
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to cms_rooms_path(id: @room.id)
      flash[:success] = "New Room was created"
    else
      render :new
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(room_params)
      redirect_to cms_rooms_path(id: @room.id)
      flash[:success] = "Update success"
    else
      redirect_to cms_rooms_path
      flash[:error] = "update fail"
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def index
    @rooms = Room.order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
    room = Room.find(params[:id])
    if room.destroy
      redirect_to cms_rooms_path
    end
  end

  private

    def room_params
      params.require(:room).permit(:id, :name, :room_type, :adults, :childrens, :price, :room_icon)
    end
end
