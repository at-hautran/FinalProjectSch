require 'test_helper'

class Cms::RoomCannotChoosesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get cms_room_cannot_chooses_update_url
    assert_response :success
  end

  test "should get index" do
    get cms_room_cannot_chooses_index_url
    assert_response :success
  end

end
