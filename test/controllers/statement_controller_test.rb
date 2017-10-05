# frozen_string_literal: true

require "test_helper"

class StatementControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get statement_url(statements(:one))
    assert_response :success
  end
end
