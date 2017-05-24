module Cms::UsersHelper
  def user_avartar user
    url = user.user_icon.url
    url.blank? ? image_tag('no_avatar.jpeg', class: "img-circle img-responsive") : image_tag(url, class: "img-circle img-responsive")
  end
end
