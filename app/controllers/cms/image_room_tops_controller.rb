class Cms::ImageRoomTopsController < Cms::ApplicationController
  before_action :init_record, :check_valid_params, only: :update

  def index
    @image_room_tops = ImageRoomTop.order(:image_room_top_number).all
  end

  def update
    if flash[:errors].blank?
      binding.pry
      ImageRoomTop.update_rooms(image_room_top_params)
    end
    redirect_to cms_image_room_tops_url
  end

  def init_record
    ImageRoomTop.init_record
  end

  def check_valid_params
    flash[:errors] = ImageRoomTop.check_valid_params image_room_top_params
  end

  def image_room_top_params
    params.require(:image_room_tops).map {|a| a.permit(:image_room_top_number, :room_id)}
  end
end
