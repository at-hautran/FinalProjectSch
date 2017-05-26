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
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
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
    item = InvoicePrinter::Document::Item.new(
      name: 'Web consultation',
      quantity: nil,
      unit: 'hours',
      price: '$ 25',
      tax: '$ 1',
      amount: '$ 100'
    )

    invoice = InvoicePrinter::Document.new(
      number: '201604030001',
      provider_name: 'Business s.r.o.',
      provider_tax_id: '56565656',
      provider_tax_id2: '465454',
      provider_street: 'Rolnicka',
      provider_street_number: '1',
      provider_postcode: '747 05',
      provider_city: 'Opava',
      provider_city_part: 'Katerinky',
      provider_extra_address_line: 'Czech Republic',
      purchaser_name: 'Adam',
      purchaser_tax_id: '',
      purchaser_tax_id2: '',
      purchaser_street: 'Ostravska',
      purchaser_street_number: '1',
      purchaser_postcode: '747 70',
      purchaser_city: 'Opava',
      purchaser_city_part: '',
      purchaser_extra_address_line: '',
      issue_date: '19/03/3939',
      due_date: '19/03/3939',
      subtotal: '175',
      tax: '5',
      tax2: '10',
      tax3: '20',
      total: '$ 200',
      bank_account_number: '156546546465',
      account_iban: 'IBAN464545645',
      account_swift: 'SWIFT5456',
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
      if @booking_service.save
        flash.now[:success] = "update success"
      else
      end
      @booking = Booking.find(service_params[:booking_id])
      @booking_services = BookingService.order(created_at: :desc).includes(:service).where(booking_id: service_params[:booking_id])
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
