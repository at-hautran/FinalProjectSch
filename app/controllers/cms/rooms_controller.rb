class Cms::RoomsController < Cms::ApplicationController
  before_action :check_admin, only:[:new, :create, :edit, :update, :destroy]
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
    if params[:check_in].present? && params[:check_out].present? || params[:booking_edit].present?
      @rooms = Room.get_emptys(params[:check_in], params[:check_out])      if params[:empty].present? || params[:booking_edit].present?
      @rooms = Room.get_are_usings(params[:check_in], params[:check_out])  if params[:in_use].present?
    else
      @rooms = Room.all
    end
    if params[:price].present?
      @rooms = @rooms.order(:price)                              if params[:price] == 1
      @rooms = @rooms.order(price: :desc)                        if params[:price] == -1
    end
    @rooms = @rooms.where("adults > ?", params[:adults])         if params[:adults].present?
    @rooms = @rooms.where("childrens > ?", params[:childrens]) if params[:childrens].present?
    @rooms = @rooms.order(created_at: :desc).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def admin_find
    @rooms = Room.where(name: params[:name])
    @rooms = @rooms.order(created_at: :desc).page(params[:page]).per(10)
    @rooms = @rooms.page(params[:page]).per(10)
    render 'index'
  end

  def employee_find_rooms
    @rooms = Room.get_emptys(params[:check_in], params[:check_out])
    @rooms = @rooms.where("adults >= ?", params[:adults]) if params[:adults].present?
    @rooms = @rooms.where("childrens >= ?", params[:childrens]) if params[:childrens].present?
    @rooms = @rooms.order(created_at: :desc).page(params[:page]).per(10)
    render 'index'
  end

  def bookings
    @room = Room.find(params[:id])
    @bookings = @room.bookings.where("status != ? AND verified IS ?", 'watting', true)
  end

  def index_bookings
    @rooms = Room.all.includes(:bookings)
  end

  def all_bookings
    @rooms = Room.includes(:bookings).all
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
