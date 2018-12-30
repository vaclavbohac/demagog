# frozen_string_literal: true

require "elasticsearch/model"

class SearchController < ApplicationController
  def index
    @results = Elasticsearch::Model.search(params[:query], [Article, Page, Statement]).records.to_a
  end
end
