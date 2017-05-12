class HomepagesController < ApplicationController
  def home
    @top_images = TopImage.where("top_choosed_number > ?", 0)
    @rooms = Room.joins(:image_room_tops).order('image_room_tops.image_room_top_number ASC')
  end

  def index
  end

  def booking
  end

  def help
  end

  def event
  end
end