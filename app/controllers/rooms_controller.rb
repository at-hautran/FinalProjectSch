class RoomsController < ApplicationController
  def index
    @rooms = Room.get_emptys(params[:check_in], params[:check_out])
    @rooms = @rooms.where("adults >= ?", params[:adults]) if params[:adults].present?
    @rooms = @rooms.where("childrens >= ?", params[:childrens]) if params[:childrens].present?
    @rooms = @rooms.order(created_at: :desc).page(params[:page]).per(9)
  end
end
