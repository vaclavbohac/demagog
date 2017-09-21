# frozen_string_literal: true

class Party < ApplicationRecord
  has_many :speakers, through: :membership
  belongs_to :attachment, optional: true
end
