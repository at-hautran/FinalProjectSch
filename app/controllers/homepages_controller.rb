class HomepagesController < ApplicationController
  def home
    @top_images = TopImage.where("top_choosed_number > ?", 0)
    @rooms = Room.limit(3)
  end

  def booking
  end

  def help
  end
end