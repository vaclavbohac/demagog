# frozen_string_literal: true

class SpeakerController < ApplicationController
  def index
    @speakers = Speaker.top_speakers
    @parties = Party.min_members(3)
  end

  def show
    @speaker = Speaker.find(params[:id])
  end
end
