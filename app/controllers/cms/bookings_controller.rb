class Cms::BookingsController < Cms::ApplicationController
  before_action :check_room_can_use, only: [:update]
  before_action :check_room_can_use_create, only: [:create]
  attr_accessor :room, :current_booking

  def new
    @room = Room.find(params[:room_id])
    @bookings = @room.bookings.build
  end

  def index
    @bookings = Booking.all
    @bookings = Booking.search(search_params, @bookings) if search_params.present?
    @bookings = @bookings.order(created_at: :desc).includes(:room, :customer).page(params[:page]).per(20)
  end

  def create
    if flash[:errors].blank?
      customer_ava = Customer.find_by(email: customer_params[:email])
      customer = customer_ava.present? ? customer_ava : Customer.create(customer_params)
      @booking = customer.bookings.build booking_params
      @booking.price = room.price
      @booking.verified = true
      @booking.verified_at = Time.zone.now
      @booking.status = :accepted
      if @booking.save
        booking_no = customer.bookings.count
        flash[:success] = "Booking succesful"
        redirect_to edit_cms_booking_path(@booking.id)
      else
        @room = Room.find(booking_params[:room_id])
        render action: :new
      end
    else
      @room = Room.find(booking_params[:room_id])
      render action: :new
    end
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
  end

  def update
    @booking = current_booking
    if params[:commit].blank? && params[:update].present? && (@booking.waitting?|| @booking.accepted? || @booking.in_use)
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
          redirect_to edit_cms_booking_path(params[:id])
        end
        if params[:commit] == 'finish' && @booking.may_finish?
          @booking.finish
          @booking.save
          redirect_to edit_cms_booking_path(params[:id])
        end
      end
    end
  end

  def pay
    @booking = Booking.find(params[:id])
    total_price = (((@booking.check_out - @booking.check_in)/1.day.to_i + 1).to_i)*(@booking.price.to_i)
    @booking.total_payed = total_price
    @booking.save
    redirect_to cms_booking_new_services_url(params[:id])
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
    # @avaiable_bookings = Booking.where(room_id: @booking.room_id)
  end

  def new_services
    @booking = Booking.find(params[:id])
    @booking_services = BookingService.order(created_at: :desc).includes(:service).where(booking_id: params[:id])
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
      @booking = Booking.find(@booking_service.booking_id)
      @booking_services = BookingService.order(created_at: :desc).includes(:service).where(booking_id: @booking.id)
      flash.now[:success] = "update success"
      # redirect_to cms_booking_new_services_url service_params[:booking_id]
      respond_to do |format|
        format.html
        format.js
      end
    else
      flash.now[:fail] = "service was closed"
      @booking = Booking.find(service_params[:booking_id])
      @booking_services = BookingService.includes(:service).where(booking_id: params[:booking_id])
      @services = Service.order(status: :desc)
      @services = @services.page(params[:page]).per(25)
      # render :new_services
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def watting_bookings
    @bookings = Booking.where(verified: true, status: :waitting)
    @bookings = @bookings.includes(:room, :customer).page(params[:page]).per(20)
    render :index
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

    # def booking_params
    #   params.require(:booking).permit(:adults, :childrens, :check_in, :check_out, :comments)
    # end
  def customer_params
    params.require(:customer).permit(:name, :email, :phonenumber, :street,
                                   :number_street, :city, :postcode, :country)
  end

  def booking_params
    params.require(:booking).permit(:childrens, :adults, :check_in, :check_out, :room_id, :comments)
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
        self.current_booking = Booking.find(params[:id])
        flash[:errors] = Room.check_schedule(self.room, booking_params[:check_in], booking_params[:check_out], current_booking.id)
        flash[:errors] = flash[:errors].to_s + Room.check_number_peoples(room, booking_params[:adults].to_i, booking_params[:childrens].to_i).to_s
        flash[:errors] = flash[:errors].to_s + Room.check_room_is_allow(self.room.id, booking_params[:check_in], booking_params[:check_out]).to_s
      end
    end

    def check_room_can_use_create
      self.room = Room.find(booking_params[:room_id])
      flash[:errors] = Room.check_schedule(self.room, booking_params[:check_in], booking_params[:check_out])
      flash[:errors] = flash[:errors].to_s + Room.check_number_peoples(room, booking_params[:adults].to_i, booking_params[:childrens].to_i).to_s
      flash[:errors] = flash[:errors].to_s + Room.check_room_is_allow(self.room.id, booking_params[:check_in], booking_params[:check_out]).to_s
    end

    def service_params
      #lack validate of booking_id and service_id present
      params.permit(:id, :booking_id, :service_id, :number, :time)
    end

    def search_params
      params.fetch(:search, {})
    end
end
