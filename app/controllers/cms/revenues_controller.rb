class Cms::RevenuesController < Cms::ApplicationController
  def index
    current_month = Time.zone.now.month
    current_year = Time.zone.now.year
    @dates_data = get_date_incomes_date(params['start_date'])
    @last_in_comes = Booking.get_last_in_comes(params['start_date'])
    @current_in_comes = Booking.get_current_in_comes(params['start_date'])
  end
end
