# frozen_string_literal: true

class Segment < ApplicationRecord
  has_many :statements, through: SegmentHasStatement
  has_many :segments, through: ArticleHasSegment
end
