class Cms::BookingsController < Cms::ApplicationController
  def index
    @bookings = Booking.includes(:user, :customer, :room).all.page(params[:page]).per(20)
  end

  def update
    binding.pry
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                     :number_street, :city, :postcode, :country)
  end

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :room_name, :comments)
  end
end
