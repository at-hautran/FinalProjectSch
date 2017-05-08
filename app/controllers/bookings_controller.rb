class BookingsController < ApplicationController
  before_action :check_room_can_use, only: :create
  attr_accessor :room

  def new
    @room = Room.find(params[:room_id])
    @bookings = @room.bookings.build
  end

  def create
    if flash[:errors].blank?
      customer_ava = Customer.find_by(email: customer_params[:email])
      customer = customer_ava.present? ? customer_ava : Customer.create(customer_params)
      @booking = customer.bookings.build booking_params
      if @booking.save
        booking_no = customer.bookings.count
        VerifyBookMailer.verify_email(@booking, booking_no).deliver
        flash.now[:success] = " Thank for your booking \n
                                You booked in room #{@booking.room.name} \n
                                Please check your mail, after 1 days from now\n
                                if you still not check, your booking will be cancel"
        redirect_to booking_watting_verify_url(@booking)
      else
        @room = Room.find(booking_params[:room_id])
        render action: :new
      end
    end
    redirect_to new_booking_url(room_id: booking_params[:room_id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                     :number_street, :city, :postcode, :country)
  end

  def booking_params
    params.require(:booking).permit(:childrens, :adults, :check_in, :check_out, :room_id, :comments)
  end

  def check_room_can_use
    self.room = Room.find(booking_params[:room_id])
    flash[:errors] = Room.check_schedule(self.room, booking_params[:check_in], booking_params[:check_out])
    flash[:errors] = flash[:errors].to_s + Room.check_number_peoples(room, booking_params[:adults].to_i, booking_params[:childrens].to_i).to_s
  end
end
