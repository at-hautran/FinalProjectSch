class RoomsController < ApplicationController
  before_action :index, :check_valid_params

  def index
    @rooms = Room.get_emptys(params[:check_in], params[:check_out])
    @rooms = @rooms.where("adults >= ?", params[:adults]) if params[:adults].present?
    @rooms = @rooms.where("childrens >= ?", params[:childrens]) if params[:childrens].present?
    @rooms = @rooms.order(created_at: :desc).page(params[:page]).per(9)
  end

  def check_valid_params
    redirect_to root_url if params[:check_in].blank? || params[:check_out].blank? || params[:check_in] > params[:check_out] || Time.zone.now.strftime('%Y-%m-%d') > params[:check_in] || Time.zone.now > params[:check_out]
  end
end
