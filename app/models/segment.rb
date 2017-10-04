# frozen_string_literal: true

class Segment < ApplicationRecord
  TYPE_TEXT = "text"
  TYPE_STATEMENTS_SET = "statements_set"

  has_many :statements, through: SegmentHasStatement
  has_many :segments, through: ArticleHasSegment

  def is_text?
    segment_type == Segment::TYPE_TEXT
  end
end
