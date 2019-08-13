# frozen_string_literal: true

require "test_helper"

class SpeakerMatchingNameTest < ActiveSupport::TestCase
  test "#matching_name should be case insensitive" do
    speaker = create(:speaker, first_name: "James")

    assert_equal(speaker, Speaker.matching_name("james").first)
  end

  test "#matching_name should search in speaker full name" do
    speaker = create(:speaker, first_name: "James", last_name: "Bond")

    assert_equal(speaker, Speaker.matching_name("james bond").first)
  end

  test "#matching_name should search in unaccented version of the name" do
    speaker = create(:speaker, first_name: "Jiří", last_name: "Stříbrný")

    assert_equal(speaker, Speaker.matching_name("jiri stribrny").first)
  end

  test "#matching_name should search in accented version of the name" do
    speaker = create(:speaker, first_name: "Jiří", last_name: "Stříbrný")

    assert_equal(speaker, Speaker.matching_name("Jiří Stříbrný").first)
  end
end
