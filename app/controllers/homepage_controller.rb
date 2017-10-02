# frozen_string_literal: true

class HomepageController < ApplicationController
  def index
    @cover_story = Article.cover_story
    @interesting_statements = Statement.interesting_statements
  end
end
