# frozen_string_literal: true

require "test_helper"

class ArticleStatsBuilderTest < ActiveSupport::TestCase
  test "building source stats" do
    stats_builder = Stats::Article::StatsBuilder.new Stats::StatsCache.new Store::HashStore.new

    expected_stats = {
      true: 3,
      untrue: 0,
      unverifiable: 0,
      misleading: 0
    }

    speaker = get_speaker
    article = get_article(speaker.statements)

    assert_equal(expected_stats, stats_builder.build(article, speaker))
  end

  test "invalidate source stats" do
    store = Store::HashStore.new
    stats_builder = Stats::Article::StatsBuilder.new Stats::StatsCache.new store

    speaker = get_speaker
    article = get_article(speaker.statements)

    stats_builder.build(article, speaker)

    stats_builder.invalidate(article)

    assert_empty store
  end

  private
    def get_speaker
      source = create(:source)

      create(:speaker, statement_source: source)
    end

    def get_article(statements)
      segment = create(:segment, statements: statements)

      create(:fact_check, segments: [segment])
    end
end
