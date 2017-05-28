module Cms::BookingsHelper
  STATUS_COLOR = {  'watting'  => 'yellow',
                    'cancel'   => '#f00',
                    'accepted' => '#48D1CC',
                    'in_use'   => '#0f0',
                    'finished' => '#FFA500'
                    }.freeze
  def pay_link_to booking
    total_price = (((@booking.check_out - @booking.check_in)/1.day.to_i + 1).to_i)*(@booking.price.to_i)
    if booking.total_payed == nil || booking.total_payed < total_price
      link_to 'paid', cms_booking_pay_path(booking.id), class: 'btn btn-success btn-xs', method: :put
    elsif booking.total_payed > total_price
      link_to 'change', cms_booking_pay_path(booking.id), class: 'btn btn-success btn-xs', method: :put
    else
    end
  end

  def cal_prices(booking)
    booking.total_payed
  end

  def get_incomes(bookings)
    incomes = 0
    bookings.each do |booking|
      incomes = incomes + cal_prices(booking) + booking.total_services_payed
    end
    incomes
  end

  def get_incomes_services(booking)
    service_incomes = 0
    booking.each do |booking|
      service_incomes = service_incomes + booking.total_services_payed
    end
    service_incomes
  end
end
