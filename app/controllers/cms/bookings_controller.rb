class Cms::BookingsController < Cms::ApplicationController
  before_action :check_room_can_use, only: :update
  attr_accessor :room

  def index
    @bookings = Booking.all
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
    else
      if params[:commit].present?
        @booking.accept if params[:commit] == 'accept' && @booking.may_accept?
        @booking.cancel if params[:commit] == 'cancel' && @booking.may_cancel?
        @booking.in_use if params[:commit] == 'in_use' && @booking.may_in_use?
        @booking.finish if params[:commit] == 'finish' && @booking.may_finish?
        @booking.save
      end
    end
    redirect_to edit_cms_booking_path(params[:id])
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
    binding.pry
    @booking = Booking.find(params[:id])
    @services = Service.order(:status)
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
end
