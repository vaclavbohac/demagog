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

  def correct_assessment
    Assessment.find_by(
      statement: self,
      evaluation_status: Assessment::STATUS_CORRECT
    )
  end
end
