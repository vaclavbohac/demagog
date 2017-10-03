# frozen_string_literal: true

class ArticleController < ApplicationController
  def index
    @article = Article.find(params[:id])
  end
end
