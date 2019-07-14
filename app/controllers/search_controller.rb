# frozen_string_literal: true

require "elasticsearch/model"

class SearchController < ApplicationController
  def index
    @query = params[:q] || ""
    @type = params[:type]
    @type = nil unless ["articles", "speakers", "statements"].include?(@type)

    @articles = Article.search_published(escape_query(@query))
    @speakers = Speaker.search(escape_query(@query))
    @statements = Statement.search_published(escape_query(@query))

    @type_results = case @type
                    when "articles"
                      @articles
                    when "speakers"
                      @speakers
                    when "statements"
                      @statements
    end
  end

  private

    def escape_query(query)
      escaped_characters = Regexp.escape('\\/+-&|!(){}[]^~*?:')
      query.gsub(/([#{escaped_characters}])/, '\\\\\1')
    end
end
