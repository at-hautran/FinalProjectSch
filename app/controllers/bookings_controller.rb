class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @bookings = @room.bookings.build
  end

  def create
    # Booking.book_ticket(customer_params, booking_params)
    customer = Customer.create customer_params
    @booking = customer.bookings.build booking_params
    @booking.status = 'waiting'
    # if current_user && current_user.role == 'admin'
    #   booking.user_id = current_user.id
    #   booking.status = 'accept'
    # end
    if @booking.save
      redirect_to
    else
      @room = Room.find(booking_params[:room_id])
      render action: :new
    end
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                     :number_street, :city, :postcode, :country)
  end

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :room_id, :comments)
  end
end
