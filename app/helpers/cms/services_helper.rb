module Cms::ServicesHelper
  def service_tag image
    url = image.service_icon.present? ? image.service_icon.thumb250.url : 'a'
    image_tag url
  end

  STATUS_COLOR = {'new'   => '#00FFFF',
                  'open'  => '#00FF00',
                  'close' => '#FF4500'
                  }
end
