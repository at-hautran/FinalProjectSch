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
    @room = Room.find(Room_params[:id])
    if @room.update_attributes(room_params)
      redirect_to cms_Rooms_path(id: @room.id)
      flash[:success] = "Update success"
    else
      render :new
      flash[:error] = "update fail"
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def index
    @rooms = Room.all
  end

  private

    def room_params
      params.require(:room).permit(:name, :type, :adults, :childrens, :price)
    end
end
