# frozen_string_literal: true

class SegmentHasStatement < ApplicationRecord
  belongs_to :statement
  belongs_to :segment
end
