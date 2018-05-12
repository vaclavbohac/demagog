# frozen_string_literal: true

require "test_helper"

class Admin::FileUploadControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "upload profile picture requires authorization" do
    fixture = fixture_file_upload("files/speaker.png", "image/png")

    speaker = speakers(:one)

    post "upload_profile_picture", params: { id: speaker.id, file: fixture }

    assert_response 302
  end

  test "post speaker portrait" do
    sign_in users(:one)

    fixture = fixture_file_upload("files/speaker.png", "image/png")

    speaker = speakers(:one)

    post "upload_profile_picture", params: { id: speaker.id, file: fixture }

    assert Speaker.find(speaker.id).avatar.attached?

    assert_response :success
  end
end
