class Cms::ServicesController < Cms::ApplicationController
  def new
    @service = Service.new
  end

  def create
  end

  def index
    @services = Service.all
  end

  def show
    @service = Service.find(params[:id])
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
  end

  def service_params
  end
end
