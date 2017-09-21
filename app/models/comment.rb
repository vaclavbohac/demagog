# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :statement
  belongs_to :user
end
