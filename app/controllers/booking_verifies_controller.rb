class BookingVerifiesController < ApplicationController
  def edit
    customer = Customer.find_by(email: "h0977534303@gmail.com")
    booking = Booking.find(params[:booking_id])
    if booking && !booking.verified? && booking.authenticated?(:verification, params[:id])
      booking.update_attribute(:verified,    true)
      booking.update_attribute(:verified_at, Time.zone.now)
      @booking = booking
      redirect_to booking_verify_success_url(booking)
    else
      redirect_to root_url
    end
  end

  def success
    @booking = Booking.find(params[:format])
  end

  def watting_verify
    @booking = Booking.find(params[:id])
  end
end