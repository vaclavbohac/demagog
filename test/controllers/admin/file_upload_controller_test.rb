# frozen_string_literal: true

require "test_helper"

class Admin::FileUploadControllerTest < ActionDispatch::IntegrationTest
  test "post speaker portrait" do
    fixture = fixture_file_upload("files/speaker.png", "image/png")

    speaker = speakers(:one)

    post "/admin/profile-picture/#{speaker.id}", params: { file: fixture }

    assert Speaker.find(speaker.id).avatar.attached?

    assert_response :success
  end
end
