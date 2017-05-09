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
    @booking_service = BookingService.find(params[:id])
    if booking_service_params[:commit].present?
      @booking_service.booked if params[:commit] == 'booked' && @booking_service.may_booked?
      @booking_service.cancel if params[:commit] == 'cancel' && @booking_service.may_cancel?
      @booking_service.save
      # @booking = @booking_service.booking
      # @booking_services = BookingService.includes(:service).where(booking_id: @booking.id)
      # @services = Service.order(status: :desc)
      # @services = @services.page(params[:page]).per(25)
      redirect_to cms_booking_new_services_url(@booking_service.booking_id)
    end
  end

  def edit
    @booking_service = BookingService.find(params[:id])
  end

  def destroy
    BookingService.find(params[:id]).delete
  end

  # def booking_service_params
  #   params.require(:booking_service).permit()
  # end

  def booking_service_params
    params.permit(:commit)
  end
end
