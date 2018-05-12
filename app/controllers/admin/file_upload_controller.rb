# frozen_string_literal: true

class Admin::FileUploadController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!

  def upload_profile_picture
    params.permit!

    speaker = Speaker.find(params[:id])

    speaker.avatar.attach(
      io: params[:file].to_io,
      filename: params[:file].original_filename,
      content_type: params[:file].content_type
    )

    speaker.save!

    head :ok
  end

  def delete_profile_picture
    begin
      speaker = Speaker.find(params[:id])

      speaker.avatar.purge
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end
end
