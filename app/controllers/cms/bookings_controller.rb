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
    @bookings = @bookings.where(verified: true)
    @bookings = @bookings.order(created_at: :desc).includes(:room, :customer).page(params[:page]).per(15)
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
  end

  def update
    @booking = current_booking
    if params[:commit].blank? && params[:update].present? && (@booking.waitting?|| @booking.accepted? || @booking.in_use?)
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
          @booking.finished_at = Time.zone.now
          @booking.total_services_payed = service_prices(@booking)
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
    @booking.save(validate: false)
    redirect_to cms_booking_new_services_url(params[:id])
  end

  def show
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def new_services
    @booking = Booking.find(params[:id])
    @booking_services = BookingService.order("CASE status WHEN 'watting' THEN 1
                                              WHEN 'booked' THEN 2
                                              WHEN 'cancel' THEN 3 END, created_at desc").includes(:service).where(booking_id: params[:id])
    @services = Service.order(status: :desc)
    @services = @services.page(params[:page]).per(25)
  end

  def invoice
    booking = Booking.find(params[:id])
    customer = booking.customer
    room = booking.room
    total_days = ((booking.check_out- booking.check_in)/(1.day)).to_i + 1
    unless booking.total_payed == booking.price*total_days
      total_price = booking.price*total_days - booking.total_payed
      extra_days = total_price/booking.price
      i_check_out = booking.check_out
      i_check_in = booking.check_out - extra_days.to_i.day
      days = ((i_check_out - i_check_in)/(1.day)).to_i
      item = InvoicePrinter::Document::Item.new(
        name: "Room#{room.name}",
        quantity: days.to_s + " days(check in from #{(i_check_in + 1.day).strftime('%Y-%m-%d')} to #{i_check_out.strftime('%Y-%m-%d')})",
        price: booking.price*85/100,
        amount: '$ ' + (total_price*85/100).to_i.to_s
      )

      invoice = InvoicePrinter::Document.new(
        number: "a",
        provider_name: 'My Hotel',
        provider_tax_id: '56565656',
        provider_tax_id2: '465454',
        provider_street: 'Cua Dai',
        provider_street_number: '1',
        provider_city: 'Hoi An',
        purchaser_name: customer.name,
        purchaser_street: customer.street,
        purchaser_street_number: customer.number_street,
        purchaser_city: customer.city,
        purchaser_postcode: customer.postcode,
        due_date: (Time.zone.now + 7.hour).strftime('%Y-%m-%d %I:%M:%S %p'),
        subtotal: (total_price*85/100).to_i,
        tax: (total_price*10/100).to_i,
        tax2: (total_price*5/100).to_i,
        total: '$ ' + total_price.to_i.to_s,
        items: [item],
        note: 'A note...'
      )
      respond_to do |format|
        format.pdf {
          @pdf = InvoicePrinter.render(
            document: invoice
          )
          send_data @pdf, type: 'application/pdf', disposition: 'inline'
        }
      end
    else
      redirect_to cms_booking_new_services_url(params[:id])
    end
  end

  def create_services
    @service = Service.find(service_params[:service_id])
    if @service.open?
      @booking_service = BookingService.new service_params
      @booking_service.price = @service.price
      @booking_service.user_id = current_user.id
      if @booking_service.save
        flash.now[:success] = "update success"
      else
      end
      @booking = Booking.find(service_params[:booking_id])
      @booking_services = BookingService.order(created_at: :desc).includes(:service).where(booking_id: service_params[:booking_id])
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
      params.permit(:id, :booking_id, :service_id, :number, :time)
    end

    def search_params
      params.fetch(:search, {})
    end
end
