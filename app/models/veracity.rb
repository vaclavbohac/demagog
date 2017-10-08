# frozen_string_literal: true

class Veracity < ApplicationRecord
  TRUE = "true"
  UNTRUE = "untrue"
  MISLEADING = "misleading"
  UNVERIFIABLE = "unverifiable"

  ID_TRUE = 1
  ID_UNTRUE = 2
  ID_MISLEADING = 3
  ID_UNVERIFIABLE = 4

  DEFAULT_NAMES = {
      Veracity::ID_TRUE => "true",
      Veracity::ID_UNTRUE => "untrue",
      Veracity::ID_MISLEADING => "misleading",
      Veracity::ID_UNVERIFIABLE => "unverifiable"
  }

  has_many :assessments

  def default_name
    Veracity::DEFAULT_NAMES[id]
  end

  def self.default_name(id)
    Veracity::DEFAULT_NAMES[id]
  end
end
