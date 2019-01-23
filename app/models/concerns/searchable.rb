# frozen_string_literal: true

require "active_support/concern"
require "elasticsearch/model"

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "#{self.model_name.collection}_#{Rails.env}"
  end
end
