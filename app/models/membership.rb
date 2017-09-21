# frozen_string_literal: true

class Membership < ApplicationRecord
  belongs_to :party
  belongs_to :speaker
end
