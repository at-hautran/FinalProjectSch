require 'test_helper'

class Cms::AllowIpAddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cms_allow_ip_addresses_new_url
    assert_response :success
  end

  test "should get create" do
    get cms_allow_ip_addresses_create_url
    assert_response :success
  end

  test "should get delele" do
    get cms_allow_ip_addresses_delele_url
    assert_response :success
  end

end
