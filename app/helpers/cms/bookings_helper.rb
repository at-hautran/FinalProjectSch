module Cms::BookingsHelper
  STATUS_COLOR = {  'watting'  => 'yellow',
                    'cancel'   => '#f00',
                    'accepted' => '#48D1CC',
                    'in_use'   => '#0f0',
                    'finished' => '#FFA500'
                    }.freeze
  def pay_link_to booking
    total_price = (((@booking.check_out - @booking.check_in)/1.day.to_i + 1).to_i)*(@booking.price.to_i)
    if booking.total_payed < total_price
      link_to 'paid', cms_booking_pay_path(booking.id), class: 'btn btn-success btn-xs', method: :put
    elsif booking.total_payed > total_price
      link_to 'change', cms_booking_pay_path(booking.id), class: 'btn btn-success btn-xs', method: :put
    else
    end
  end
end
