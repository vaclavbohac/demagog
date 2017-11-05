# frozen_string_literal: true

class ArchiveController < ApplicationController
  def index
    @articles = Article
      .where(published: true)
      .order(published_at: :desc)
      .page(params[:page])

    # expires_in 1.hour, public: true
  end
end
