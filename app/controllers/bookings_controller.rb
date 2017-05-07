class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @bookings = @room.bookings.build
  end

  def create
    customer_ava = Customer.find_by(email: customer_params[:email])
    customer = customer_ava.present? ? customer_ava : Customer.create(customer_params)
    @booking = customer.bookings.build booking_params
    @booking.status = 'waiting'
    if @booking.save
      booking_no = customer.bookings.count
      VerifyBookMailer.verify_email(@booking, booking_no).deliver
      redirect_to bookings
    else
      @room = Room.find(booking_params[:room_id])
      render action: :new
    end
  end

  def index
    # @bookings = Booking.except_booked(params[:check_in], params[:check_out])
    #                                                                 if params[:check_in].present? && params[:check_out].present?
    # @bookings = Booking.all                                         if params[:check_in].blank? && params[:check_out].blank?
    # @bookings = @bookings.where(status: params[:status])            if params[:status].present?
    # @bookings = @bookings.where("adults > ?", params[:adults])      if params[:adults].present?
    # @bookings = @bookngs.where("childrens > ?", params[:childrens]) if params[:childrens].present?
    # @bookings = @bookings.order(:price)                             if params[:price].present? && params[:price] == 1
    # @bookings = @bookings.order(price: :desc)                       if params[:price].present? && params[:price] == -1
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                     :number_street, :city, :postcode, :country)
  end

  def booking_params
    params.require(:booking).permit(:childrens, :adults, :check_in, :check_out, :room_id, :comments)
  end
end
