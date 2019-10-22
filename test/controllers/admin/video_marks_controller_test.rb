# frozen_string_literal: true

require "test_helper"

class Admin::VideoMarksControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "should cause a redirect if not logged in" do
    get :edit, params: { id: 1 }

    assert_redirected_to "http://test.host/"
  end

  test "should return 404 if source not found" do
    sign_in create(:user)

    get :edit, params: { id: -1 }

    assert_response :not_found
  end

  test "should return 200" do
    source = create(:source)

    sign_in create(:user)

    get :edit, params: { id: source.id }

    assert_response :success
  end
end
