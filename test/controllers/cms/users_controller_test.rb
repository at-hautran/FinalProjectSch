require 'test_helper'

class Cms::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cms_user = cms_users(:one)
  end

  test "should get index" do
    get cms_users_url
    assert_response :success
  end

  test "should get new" do
    get new_cms_user_url
    assert_response :success
  end

  test "should create cms_user" do
    assert_difference('Cms::User.count') do
      post cms_users_url, params: { cms_user: { address: @cms_user.address, email: @cms_user.email, gender: @cms_user.gender, name: @cms_user.name, password: @cms_user.password, phone_number: @cms_user.phone_number, position: @cms_user.position, role: @cms_user.role } }
    end

    assert_redirected_to cms_user_url(Cms::User.last)
  end

  test "should show cms_user" do
    get cms_user_url(@cms_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_cms_user_url(@cms_user)
    assert_response :success
  end

  test "should update cms_user" do
    patch cms_user_url(@cms_user), params: { cms_user: { address: @cms_user.address, email: @cms_user.email, gender: @cms_user.gender, name: @cms_user.name, password: @cms_user.password, phone_number: @cms_user.phone_number, position: @cms_user.position, role: @cms_user.role } }
    assert_redirected_to cms_user_url(@cms_user)
  end

  test "should destroy cms_user" do
    assert_difference('Cms::User.count', -1) do
      delete cms_user_url(@cms_user)
    end

    assert_redirected_to cms_users_url
  end
end
