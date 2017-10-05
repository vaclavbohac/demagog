# frozen_string_literal: true

class Party < ApplicationRecord
  has_many :memberships
  has_many :speakers, through: :memberships
  belongs_to :attachment, optional: true

  def self.min_members(count)
    joins(:memberships)
      .where(memberships: { until: nil })
      .having("COUNT(memberships.id) > ?", count)
      .group(:id)
      .order(name: :asc)
  end
end
