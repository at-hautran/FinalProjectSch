class Cms::BookingsController < Cms::ApplicationController
  before_action :check_room_can_use, only: :update
  attr_accessor :room

  def index
    @bookings = Booking.all
    @bookings = Booking.search(search_params, @bookings) if search_params.present?
    @bookings = @bookings.includes(:room, :customer).page(params[:page]).per(20)
  end

  def update
    @booking = current_booking
    if params[:commit].blank? && params[:update].present? && @booking.watting?
      if flash[:errors].blank?
        @booking.update_attributes(booking_update_params)
        flash[:success] = "update success"
      else
        flash[:fails] = "update errors"
      end
      redirect_to edit_cms_booking_path(params[:id])
    else
      if params[:commit].present?
        if params[:commit] == 'accept' && @booking.may_accept?
          @booking.accept
          @booking.save
          redirect_to edit_cms_booking_path(params[:id])
        end
        if params[:commit] == 'cancel' && @booking.may_cancel?
          @booking.cancel
          @booking.save
          redirect_to edit_cms_booking_path(params[:id])
        end
        if params[:commit] == 'in_use' && @booking.may_in_use?
          @booking.in_use
          @booking.save
          render :bill
        end
        if params[:commit] == 'finish' && @booking.may_finish?
          @booking.finish
          @booking.save
          redirect_to edit_cms_booking_path(params[:id])
        end
      end
    end
  end

  # def accept
  #   current_booking.accept
  # end

  # def cancel
  #   current_booking.accept
  # end

  # def in_use
  #   current_booking.in_use
  # end

  # def finish
  #   current_booking.finish
  # end

  def show
    @booking = Booking.find(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
    # @avaiable_bookings = Booking.where(room_id: @booking.room_id)
  end

  def new_services
    @booking = Booking.find(params[:id])
    @booking_services = BookingService.includes(:service).where(booking_id: params[:id])
    @services = Service.order(status: :desc)
    @services = @services.page(params[:page]).per(25)
  end

  def create_services
    @service = Service.find(service_params[:service_id])
    if @service.open?
      @booking_service = BookingService.new service_params
      @booking_service.price = @service.price
      @booking_service.user_id = current_user.id
      @booking_service.save
      flash[:success] = "update success"
      redirect_to cms_booking_new_services_url service_params[:booking_id]
    else
      flash[:fail] = "service was closed"
      @booking = Booking.find(service_params[:booking_id])
      @booking_services = BookingService.includes(:service).where(booking_id: params[:booking_id])
      @services = Service.order(status: :desc)
      @services = @services.page(params[:page]).per(25)
      render :new_services
    end
  end

  def histories
    @booking = Booking.find(params[:id])
    @histories = @booking.audits
  end

  def bill
    @booking = Booking.find(params[:id])
  end

  def csv_bills
    @bookings = Booking.all
    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data @bookings.to_csv(%w(name phonenumber room_id email country check_in check_out adults childrens)) }
    end
  end

  private

    # def customer_params
    #   params.require(:customer).permit(:name, :email, :phonenumber, :street,
    #                                    :number_street, :city, :postcode, :country)
    # end

    def booking_params
      params.require(:booking).permit(:adults, :childrens, :check_in, :check_out, :comments)
    end

    def booking_update_params
      total_days = (booking_params[:check_out].to_time - booking_params[:check_in].to_time)/(1.day)
      booking_params.merge(total_price: total_days*room.price)
      booking_params.merge(room_id: room.id)
    end

    def current_booking
      Booking.find(params[:id])
    end

    def check_room_can_use
      if params[:commit].blank?
        self.room = Room.find_by(name: params[:room_name])
        # self.current_booking = Booking.find(params[:id])
        flash[:errors] = Room.check_schedule(self.room, booking_params[:check_in], booking_params[:check_out], current_booking.id)
        flash[:errors] = flash[:errors].to_s + Room.check_number_peoples(room, booking_params[:adults].to_i, booking_params[:childrens].to_i).to_s
      end
    end

    def service_params
      #lack validate of booking_id and service_id present
      params.permit(:id, :booking_id, :service_id, :number)
    end

    def search_params
      params.fetch(:search, {})
    end
end
