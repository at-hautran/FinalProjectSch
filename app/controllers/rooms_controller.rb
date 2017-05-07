class RoomsController < ApplicationController

  def index
    # if params[:check_in] && params[:check_out].present?
      # @rooms = Room.get_room_can_use(check_in, check_out, except_room_ids=-1)
      # @rooms = Room.all.page(params[:page]).per(10)
      # @rooms = @rooms.where(status: params[:status])            if params[:status].present?
      # @rooms = @rooms.where("adults > ?", params[:adults])      if params[:adults].present?
      # @rooms = @bookngs.where("childrens > ?", params[:childrens]) if params[:childrens].present?
      # @rooms = @rooms.order(:price)                             if params[:price].present? && params[:price] == 1
      # @rooms = @rooms.order(price: :desc)                       if params[:price].present? && params[:price] == -1
      @rooms = Room.all.page(params[:page]).per(10)
    # end
  end
end
