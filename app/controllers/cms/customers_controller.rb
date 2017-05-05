class Cms::CustomersController < Cms::ApplicationController
  def index
    @customers = Customer.all
    @customers = @customers.where(email: params[:email]) if params[:email].present?
    @customers = @customers.where(country: params[:country]) if params[:country].present?
    @customers = @customers.where(postcode: params[:postcode]) if params[:postcode].present?
    @customers = @customers.page(params[:page]).per(25)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def bookings
    @customer = Customer.find(params[:id])
    @bookings = @customer.bookings.order(:created_at).page(params[:page]).per(10)
  end
end
