# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :memberships
  has_many :parties, through: :memberships
  has_many :statements
  belongs_to :attachment

  def portrait
    attachment
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def stats
    {
      true: 5,
      untrue: 10,
      misleading: 11,
      unverifiable: 0
    }
  end
end
