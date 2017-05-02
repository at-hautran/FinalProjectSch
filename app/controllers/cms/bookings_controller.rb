class Cms::BookingsController < Cms::ApplicationController
  def index
    @bookings = Booking.includes(:user, :customer, :room).all.page(params[:page]).per(20)
    gon.rooms = Room.incremental_search Room.all
    gon.names = "aaaaa"
  end

  def update
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                     :number_street, :city, :postcode, :country)
  end

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :room_name, :comments)
  end

  def index
    @bookings = Booking.except_booked(params[:check_in], params[:check_out]) if params[:check_in].present? && params[:check_out].present?
    @bookings = Booking.all                                         if params[:check_in].blank? && params[:check_out].blank?
    @bookings = @bookings.where(status: params[:status])            if params[:status].present?
    @bookings = @bookings.where("adults > ?", params[:adults])      if params[:adults].present?
    @bookings = @bookngs.where("childrens > ?", params[:childrens]) if params[:childrens].present?
    @bookings = @bookings.order(:price)                             if params[:price].present? && params[:price] == 1
    @bookings = @bookings.order(price: :desc)                       if params[:price].present? && params[:price] == -1
  end

  def edit
    @booking = Booking.find(params[:id])
  end
end
