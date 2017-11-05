# frozen_string_literal: true

require "test_helper"

class ArchiveControllerTest < ActionDispatch::IntegrationTest
  test "should render index page" do
    get archive_url
    assert_response :success
  end
end
