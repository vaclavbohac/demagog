# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :memberships
  has_many :parties, through: :memberships
  has_many :statements
end
