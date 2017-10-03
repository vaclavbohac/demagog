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

  has_many :assessments

  def default_names
    {
      Veracity::ID_TRUE => "true",
      Veracity::ID_UNTRUE => "untrue",
      Veracity::ID_MISLEADING => "misleading",
      Veracity::ID_UNVERIFIABLE => "unverifiable"
    }
  end

  def default_name
    default_names[id]
  end
end
