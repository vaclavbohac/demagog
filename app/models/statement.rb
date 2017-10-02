# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :speaker
  belongs_to :source, optional: true
  has_many :comments
  has_many :segments, through: SegmentHasStatement

  def self.interesting_statements
    limit(4)
      .where(important: true)
      .order(excerpted_at: :desc)
  end
end
