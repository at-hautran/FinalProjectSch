class Cms::BookingsController < Cms::ApplicationController
  before_action :check_room_can_use, only: :update
  attr_accessor :room
  attr_accessor :current_booking

  def index
    @bookings = Booking.includes(:user, :customer, :room).all.page(params[:page]).per(20)
    gon.rooms = Room.incremental_search Room.all
    gon.names = "aaaaa"
  end

  def update
    if flash[:errors].blank?
      binding.pry
      current_booking.update_attributes(booking_update_params)
      flash[:success] = "update success"
    else
      flash[:fails] = "update errors"
    end
    redirect_to edit_cms_booking_path(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
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

  private

    def customer_params
      params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                       :number_street, :city, :postcode, :country)
    end

    def booking_params
      params.require(:booking).permit(:adults, :childrens, :check_in, :check_out, :comments)
    end

    def booking_update_params
      booking_params.merge(room_id: room.id)
    end

    def check_room_can_use
      self.room = Room.find_by(name: params[:room_name])
      self.current_booking = Booking.find(params[:id])
      flash[:errors] = Room.check_schedule(self.room, booking_params[:check_in], booking_params[:check_out], self.current_booking.id)
      flash[:errors] = flash[:errors].to_s + Room.check_number_peoples(room, booking_params[:adults].to_i, booking_params[:childrens].to_i).to_s
      # if room.adults < booking_params[:adults] || room.childrens < booking_params[:childrens]
    end
end
