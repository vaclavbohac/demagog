# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :speaker
  belongs_to :source
  has_many :comments
  has_many :segments, through: SegmentHasStatement
end
