# frozen_string_literal: true

class SearchController < FrontendController
  def index
    @query = params[:q] || ""
    @type = params[:type]
    @type = nil unless ["articles", "speakers", "statements"].include?(@type)

    @articles = Article.query_search_published(@query)
    @speakers = Speaker.query_search(@query)
    @statements = Statement.query_search_published_factual(@query)

    @type_results = case @type
                    when "articles"
                      @articles
                    when "speakers"
                      @speakers
                    when "statements"
                      @statements
    end
  end
end
