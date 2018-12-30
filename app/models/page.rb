# frozen_string_literal: true

require "elasticsearch/model"

class Page < ApplicationRecord
  extend FriendlyId

  include Elasticsearch::Model

  default_scope { where(deleted_at: nil) }

  scope :published, -> {
    where(published: true)
  }

  friendly_id :title, use: :slugged

  def self.matching_title(title)
    where("title LIKE ?", "%#{title}%")
  end
end
