# frozen_string_literal: true

class StatementController < ApplicationController
  def show
    @statement = Statement.find(params[:id])
  end
end
