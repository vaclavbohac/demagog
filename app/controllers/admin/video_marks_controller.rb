# frozen_string_literal: true

class Admin::VideoMarksController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :set_source, only: %i[edit]

  def edit
    return head :not_found unless @source
  end

  def create
  end

  private

  def set_source
    @source = Source.find_by(id: params[:id])
  end
end
