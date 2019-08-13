# frozen_string_literal: true

class StatementController < FrontendController
  def show
    @statement = Statement.factual_and_published.find(params[:id])
  end
end
