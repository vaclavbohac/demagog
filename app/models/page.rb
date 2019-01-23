# frozen_string_literal: true

class Page < ApplicationRecord
  extend FriendlyId

  include Searchable

  default_scope { where(deleted_at: nil) }

  scope :published, -> {
    where(published: true)
  }

  friendly_id :title, use: :slugged

  def self.matching_title(title)
    where("title LIKE ?", "%#{title}%")
  end
end
