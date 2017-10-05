# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :speaker
  belongs_to :source, optional: true
  has_many :comments
  has_many :attachments, through: :speaker
  has_many :segment_has_statements
  has_many :segments, through: :segment_has_statements
  has_many :article_has_segments, through: :segments
  has_many :articles, through: :article_has_segments

  def self.interesting_statements
    limit(4)
      .includes(:speaker, :attachments)
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
