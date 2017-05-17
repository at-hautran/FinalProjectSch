class Cms::ServicesController < Cms::ApplicationController
  before_action :check_admin, only:[:new, :create, :edit, :update, :destroy, :index]

  def new
    @service = Service.new
  end

  def create
    @service = Service.new service_params
    if @service.save
      redirect_to cms_services_url
    else
      render :new
    end
  end

  def index
    @services = Service.all.order(created_at: :desc)
    @booking = Booking.find(params[:booking_id]) if params[:booking_id].present?
    @services = Service.where(name: params[:name].split(';').map{|name| name.strip}) if params[:name].present?
    @services = @services.order(created_at: :desc).page(params[:page]).per(20)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @service = Service.find(params[:id])
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])
    if params[:commit].present?
      @service.close if params[:commit] == 'close' && @service.may_close?
      @service.open  if params[:commit] == 'open' && @service.may_open?
      if @service.save
        flash[:success] = 'Update success'
      else
        flash[:errors] = 'Update Fail'
      end
    elsif params[:update].present?
      if @service.update_attributes(service_params)
        flash[:success] = 'Update success'
      else
        flash[:errors] = 'Update Fail'
      end
    end
    redirect_to edit_cms_service_url(@service)
  end

  def destroy
    Service.find(params[:id]).delete
    redirect_to cms_services_url
  end

  def service_params
    params.require(:service).permit(:service_icon, :name, :price)
  end
end
