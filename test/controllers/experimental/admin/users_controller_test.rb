# frozen_string_literal: true

require "test_helper"

class Experimental::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup { @user = create(:user) }

  test "should get index" do
    user = create(:user, active: false, first_name: "Deactivated user")

    get experimental_admin_users_url
    assert_response :success
    assert_select ".s-users" do
      assert_select ".s-user-#{user.id}", false, "#{user.first_name} show not rendered"
    end
  end

  test "should show deactivated users on index" do
    user = create(:user, active: false, first_name: "Deactivated user")

    get experimental_admin_users_url(deactivated: true)
    assert_response :success
    assert_select ".s-users" do
      assert_select ".s-user-#{user.id}", true, "#{user.first_name} should be rendered"
    end
  end

  test "should get new" do
    get new_experimental_admin_user_url
    assert_response :success
  end

  test "should create admin_user" do
    user = build(:user)
    role = create(:role)

    assert_difference("User.count") do
      post experimental_admin_users_url, params: { user: { email: user.email, role: role.id } }
    end

    assert_redirected_to experimental_admin_user_url(User.last)
  end

  test "should show admin_user" do
    get experimental_admin_user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_experimental_admin_user_url(@user)
    assert_response :success
  end

  test "should update admin_user" do
    user = build(:user)
    role = create(:role)

    patch experimental_admin_user_url(@user), params: { user: { email: user.email, role: role.id, email_notifications: true } }
    assert_redirected_to experimental_admin_user_url(@user)
  end

  test "should update user to inactive" do
    assert_difference("User.active.count", -1) do
      patch experimental_admin_user_url(@user), params: { user: { active: false } }
    end
  end

  test "should destroy admin_user" do
    assert_difference("User.count", -1) { delete experimental_admin_user_url(@user) }

    assert_redirected_to experimental_admin_users_url
  end
end
