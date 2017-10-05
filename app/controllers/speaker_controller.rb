# frozen_string_literal: true

class SpeakerController < ApplicationController
  def show
    @speaker = Speaker.find(params[:id])
  end
end
