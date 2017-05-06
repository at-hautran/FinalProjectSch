class HomepagesController < ApplicationController
  def home
    @top_images = TopImage.where("top_choosed_number > ?", 0)
  end

  def booking
  end

  def help
  end
end