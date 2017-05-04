module BookingsHelper
  def get_booking_data(booking)
    customer = booking.customer
    concat hidden_field_tag '', booking.id, class: :id
    concat hidden_field_tag '', customer.name, class: :customer_name
    concat hidden_field_tag '', customer.phonenumber, class: :customer_phone
    concat hidden_field_tag '', customer.email, class: :customer_email
    concat hidden_field_tag '', customer.country, class: :customer_country
    concat hidden_field_tag '', booking.room.name, class: :room_name
    concat hidden_field_tag '', booking.check_in.strftime("%Y-%m-%d"), type: :date, class: :check_in
    concat hidden_field_tag '', booking.check_out.strftime("%Y-%m-%d"), type: :date, class: :check_out
    concat hidden_field_tag '', booking.status, class: :status
    concat hidden_field_tag '', booking.user.username, class: :user_name if booking.user.present?
    yield if block_given?
  end
end
