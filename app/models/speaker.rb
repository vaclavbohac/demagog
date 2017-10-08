# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :memberships
  has_many :parties, through: :memberships
  has_many :statements
  has_many :assessments, through: :statements
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

  def stats_for_debate(source)
    statements = self.statements
      .where("statements.source_id = ?", source.id)
      .where("statements.published = ?", true)

    build_stats(statements)
  end

  def stats
    statements = self.statements
      .where("statements.published = ?", true)

    build_stats(statements)
  end

  def empty_stats
    {
      true: 0,
      untrue: 0,
      misleading: 0,
      unverifiable: 0
    }
  end

  private
    def build_stats(statements)
      correct_assessments = Assessment
        .where(statement: statements)
        .where(evaluation_status: Assessment::STATUS_CORRECT)

      correct_assessments.reduce(empty_stats) do |acc, assessment|
        acc[Veracity.default_name(assessment.veracity_id).to_sym] += 1

        acc
      end
    end
end
