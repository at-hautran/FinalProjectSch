module Cms::BookingServicesHelper
  STATUS_COLOR = {'watting'   => '#00FFFF',
                  'booked'  => '#00FF00',
                  'cancel' => '#FF4500'
                  }

  def may_pay_all? booking_id
    booking_service = BookingService.where(booking_id: booking_id, pay: 'unpaid').limit(1)
    booking_service.present? ? true : false
  end
end
