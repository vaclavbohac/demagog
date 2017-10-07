# frozen_string_literal: true

class SpeakerController < ApplicationController
  def index
    @speakers = Speaker.top_speakers
    @parties = Party.min_members(3)
  end

  def show
    @speaker = Speaker.find(params[:id])
    @statements = @speaker
      .statements
      .where(published: true)
      .order(excerpted_at: :desc)
      .page(params[:page])
  end
end
