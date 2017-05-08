class Cms::BookingServicesController < Cms::ApplicationController
  def new
    @booking_service = BookingService.new
    @booking = Booking.find(params[:booking_id])
  end

  def create
  end

  def index
    @booking_services = BookingService.all
    @booking_services = @booking_services.page(params[:page]).per(10)
  end

  def update
  end

  def edit
    @booking_service = BookingService.find(params[:id])
  end

  def destroy
    BookingService.find(params[:id]).delete
  end

  def booking_service_params
    params.require(:booking_service).permit()
  end
end
