# frozen_string_literal: true

class ArticleController < ApplicationController
  def index
    @article = Article.friendly.find(params[:id])

    expires_in 1.hour, public: true
    if stale? @article, public: true
      respond_to do |format|
        format.html
      end
    end
  end
end
