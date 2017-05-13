class HomepagesController < ApplicationController
  def home
    @top_images = TopImage.where("top_choosed_number > ?", 0)
    @rooms = Room.joins(:image_room_tops).order('image_room_tops.image_room_top_number ASC')
  end

  def index
  end

  def booking
    save_with_paypal_payment
  end

  def save_with_paypal_payment
    ppr = PayPal::Recurring.new(
      token: params[:token],
      payer_id: params[:PayerID],
      description: 'a',
      amount: Room.find(1).price,
      currency: 'USD'
      )
    response = ppr.request_payment
    if response.errors.present?
      raise response.errors.inspect
    else
    end
  end

  def help
  end

  def paypal_checkout
    @room = Room.find(1)
    ppr = PayPal::Recurring.new(
      :return_url => paypal_booking_url,
      cancel_url: root_url,
      description: @room.name,
      amount: @room.price,
      currency: "USD"
      )
    response = ppr.checkout
    if response.valid?
      redirect_to response.checkout_url
    else
      binding.pry
      raise response.errors.inspect
    end
  end

  def event
  end
end