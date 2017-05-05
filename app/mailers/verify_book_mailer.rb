class VerifyBookMailer < ApplicationMailer
  default from: 'h0977534303@gmail.com'

  def verify_email(booking, booking_no)
    @booking = booking
    @url     = edit_booking_verify_url(@booking.verification_token, email: @booking.customer.email, booking_id: @booking.id, booking_no: booking_no)
    mail(to: @booking.customer.email, subject: 'Welcome to My Awesome Site')
  end
end
