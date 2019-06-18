# frozen_string_literal: true

require "elasticsearch/model"

class SearchController < ApplicationController
  def index
    query = escape_query(params[:query])

    @speakers = Speaker.search(query)
    @articles = Article.search(query)
    @statements = Statement.search_published(query)
  end

  def show
    query = escape_query(params[:query])

    @results = case params[:type].to_s.to_sym
               when :articles
                 Article.search(query)
               when :statements
                 Statement.search(query)
               when :speakers
                 Speaker.search(query)
               else
                 raise "Unknown type #{params[:type]}"
    end
  end

  private

    def escape_query(query)
      escaped_characters = Regexp.escape('\\/+-&|!(){}[]^~*?:')
      query.gsub(/([#{escaped_characters}])/, '\\\\\1')
    end
end
