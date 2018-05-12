# frozen_string_literal: true

class Admin::FileUploadController < ApplicationController
  layout false

  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!

  # https://pqina.nl/filepond/docs/patterns/api/server/
  def upload_profile_picture
    params.permit!

    speaker = Speaker.find(params[:id])

    speaker.avatar.attach(
      io: params[:file].to_io,
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )

    speaker.save!
  end

  def delete_profile_picture
    # remove the temporary image for speaker with params[:id]
    Speaker.find(params["id"])
  end
end
