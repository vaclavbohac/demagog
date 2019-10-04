require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_url
    assert_response :success
  end

  test "should create admin_user" do
    assert_difference('User.count') do
      post admin_users_url, params: { admin_user: {  } }
    end

    assert_redirected_to admin_user_url(User.last)
  end

  test "should show admin_user" do
    get admin_user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_url(@user)
    assert_response :success
  end

  test "should update admin_user" do
    patch admin_user_url(@user), params: { admin_user: {  } }
    assert_redirected_to admin_user_url(@user)
  end

  test "should destroy admin_user" do
    assert_difference('User.count', -1) do
      delete admin_user_url(@user)
    end

    assert_redirected_to admin_users_url
  end
end
