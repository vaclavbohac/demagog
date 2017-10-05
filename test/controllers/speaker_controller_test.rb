# frozen_string_literal: true

require "test_helper"

class SpeakerControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get speaker_url(speakers(:one))
    assert_response :success
  end
end
