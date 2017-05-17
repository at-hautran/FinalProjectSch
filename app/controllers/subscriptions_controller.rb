class SubscriptionsController < ApplicationController
  def new
    room = Room.find(params[:room_id])
    if params[:PayerID]
      @subcription.paypal_customer_token = params[:PayerID]
      @subcription.paypal_payment_token = params[:token]
    end
  end
end
