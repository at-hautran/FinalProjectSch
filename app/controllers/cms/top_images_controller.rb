class Cms::TopImagesController < Cms::ApplicationController
  before_action :check_top_chooseds_valid, only: :update_top_image_chooses
  def new
    @top_image = TopImage.new
  end

  def create
    @top_image = current_user.top_images.build top_image_params
    if @top_image.save
      redirect_to cms_top_images_url
    else
      render :new
    end
  end

  def show
    @top_image = TopImage.find(params[:id])
  end

  def index
    @top_images = TopImage.order(:created_at).all
    @top_images = @top_images.page(params[:page]).per(20)
  end

  def edit
    @top_image = TopImage.find(params[:id])
  end

  def destroy
    TopImage.find(params[:id]).delete
    redirect_to cms_top_images_path
  end

  def edit_top_image_chooseds
    @top_image_chooseds = TopImage.where("top_choosed_number > ?", 0)
  end

  def update_top_image_chooses
    if flash[:errors].blank?
      TopImage.update_top_image_chooses top_image_chooseds
      flash[:success] = "update success"
    end
    redirect_to cms_top_image_chooses_url
  end

  def top_image_params
    params.require(:top_image).permit(:title, :content, :top_icon)
  end

  def top_image_chooseds
    params.require(:top_images).map {|top_choosed_number| top_choosed_number.permit(:top_choosed_number, :id)}
  end

  def check_top_chooseds_valid
    flash[:errors] = TopImage.check_top_chooseds_valid top_image_chooseds
  end
end
