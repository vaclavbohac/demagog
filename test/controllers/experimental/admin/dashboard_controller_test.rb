# frozen_string_literal: true

require "test_helper"

class Experimental::Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get experimental_admin_root_url
    assert_response :success
  end
end
