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
      current_booking.update_attributes(booking_update_params)
      flash[:success] = "update success"
    else
      flash[:fails] = "update errors"
    end
    redirect_to edit_cms_booking_path(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
    # @avaiable_bookings = Booking.where(room_id: @booking.room_id)
  end

  def index
    @bookings = Booking.all
    @bookings = @bookings.includes(:room, :customer).page(params[:page]).per(20)
  end

  def histories
    @booking = Booking.find(params[:id])
    @histories = @booking.audits
  end

  private

    def customer_params
      params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                       :number_street, :city, :postcode, :country)
    end

    def booking_params
      params.require(:booking).permit(:adults, :childrens, :check_in, :check_out, :status, :comments)
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
