# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :memberships
  has_many :parties, through: :memberships
  has_many :statements
  belongs_to :attachment

  def portrait
    self.attachment
  end
end
