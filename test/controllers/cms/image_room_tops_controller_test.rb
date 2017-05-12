require 'test_helper'

class Cms::ImageRoomTopsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cms_image_room_tops_index_url
    assert_response :success
  end

  test "should get update" do
    get cms_image_room_tops_update_url
    assert_response :success
  end

end
