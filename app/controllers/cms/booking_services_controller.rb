class Cms::BookingServicesController < Cms::ApplicationController
  def new
    @booking_service = BookingService.new
    @booking = Booking.find(params[:booking_id])
  end

  def create
  end

  def index
    @booking_services = BookingService.all
    @booking_services = @booking_services.order(:created_at).includes({booking: :room}, :service).page(params[:page]).per(10)
  end

  def update
    @booking_service = BookingService.find(params[:id])
    if booking_service_params[:commit].present?
      @booking_service.booked if params[:commit] == 'booked' && @booking_service.may_booked?
      @booking_service.cancel if params[:commit] == 'cancel' && @booking_service.may_cancel?
      @booking_service.paid   if params[:commit] == 'paid'   && @booking_service.may_paid?
      @booking_service.save
      # @booking = @booking_service.booking
      # @booking_services = BookingService.includes(:service).where(booking_id: @booking.id)
      # @services = Service.order(status: :desc)
      # @services = @services.page(params[:page]).per(25)
      redirect_to cms_booking_new_services_url(@booking_service.booking_id)
    end
  end

  def waitting
    @booking_services = BookingService.where(status: :watting).order(time: :asc).includes({booking: :room}, :service).page(params[:page]).per(10)
    render :index
  end

  def paid_all
    # if params[:commit] == 'paid_all'
      BookingService.paid_all(params[:booking_id])
  # end
    redirect_to cms_booking_new_services_url(params[:booking_id])
  end

  def pay_chooseds
  end

  def invoice
    booking_services = BookingService.where(id: params['booking_service_ids'])
    items = []
    totlal_prices = 0
    booking_services.each do |booking_service|
      service = booking_service.service
      amount_after_tax = booking_service.price*booking_service.number
      item = InvoicePrinter::Document::Item.new(
        name: service.name,
        quantity: booking_service.number,
        price: booking_service.price*85/100,
        amount: '$ ' + (amount_after_tax*85/100).to_s
        # tax: amount_after_tax*10/100,
        # tax2: amount_after_tax*5/100,
        # amount_after_tax: amount_after_tax
      )
      totlal_prices = totlal_prices + amount_after_tax
      items<<item
    end

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
      subtotal: totlal_prices*85/100,
      tax: totlal_prices*10/100,
      tax2: totlal_prices*5/100,
      total: '$ ' + totlal_prices.to_s,
      bank_account_number: '156546546465',
      account_iban: 'IBAN464545645',
      account_swift: 'SWIFT5456',
      items: items,
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
