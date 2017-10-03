# frozen_string_literal: true

class HomepageController < ApplicationController
  def index
    @cover_story = Article.cover_story
    @interesting_statements = Statement.interesting_statements
    @articles = Article.where(published: true).order(published_at: :desc).limit(5)
  end
end
