module Cms::TopImagesHelper
  def image_top_tag(image)
    url = image.top_icon.present? ? image.top_icon.thumb250.url : 'a'
    image_tag url
  end
end
