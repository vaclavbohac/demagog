# frozen_string_literal: true

class Membership < ApplicationRecord
  scope :current, -> { find_by until: nil }

  belongs_to :party
  belongs_to :speaker
end
