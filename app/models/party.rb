# frozen_string_literal: true

class Party < ApplicationRecord
  has_many :memberships
  has_many :speakers, through: :memberships
  belongs_to :attachment, optional: true
end
