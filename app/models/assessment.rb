# frozen_string_literal: true

class Assessment < ApplicationRecord
  STATUS_CORRECT = "correct"
  STATUS_REMOVED = "removed"
  STATUS_TO_BE_EVALUATED = "to_be_evaluated"
  STATUS_TO_BE_CHECKED_BY_SUPERVISOR = "to_be_checked_by_supervisor"

  belongs_to :user
  belongs_to :veracity
  belongs_to :statement

  def evaluated_by_user
    self.user
  end
end
