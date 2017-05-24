module Cms::UsersHelper
  def user_avartar user, width=nil, height=nil
    url = user.user_icon.url
    if width.present? && height.present?
      url.blank? ? image_tag('no_avatar.jpeg', class: "img-circle img-responsive") : image_tag(url, class: "img-circle img-responsive", style: "width: #{width}; height: #{height};")
    else
      url.blank? ? image_tag('no_avatar.jpeg', class: "img-circle img-responsive") : image_tag(url, class: "img-circle img-responsive")
    end
  end
end
