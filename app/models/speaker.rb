# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :memberships
  has_many :parties, through: :memberships
  has_many :statements
  belongs_to :attachment

  def self.top_speakers
    joins(:statements)
      .select("speakers.*, COUNT(statements.id) as statements_count")
      .where("statements.excerpted_at >= ?", 6.months.ago)
      .group("speakers.id")
      .order("statements_count DESC")
      .limit(5)
  end

  def portrait
    attachment
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def party
    parties.last
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
