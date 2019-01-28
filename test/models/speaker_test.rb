# frozen_string_literal: true

require "test_helper"
require "sidekiq/testing"

class SpeakerTest < ActiveSupport::TestCase
  teardown do
    Sidekiq::Worker.clear_all
  end

  test "#full_name" do
    assert_equal "John Doe", build(:speaker).full_name
  end

  test "#body" do
    speaker = create(:speaker_with_party)
    body = speaker.memberships.first.body

    assert_equal(speaker.body, body)
  end

  test "indexing document on create" do
    assert_changes -> { ElasticsearchWorker.jobs.size }, "Expected job to be queued" do
      subject = Speaker.new
      subject.save!
    end
  end

  test "indexing document on update" do
    subject = create(:speaker)

    assert_changes -> { ElasticsearchWorker.jobs.size }, "Expected job to be queued" do
      subject.first_name = "Jimmy"
      subject.save!
    end
  end

  test "indexing document on destroy" do
    subject = create(:speaker)

    assert_changes -> { ElasticsearchWorker.jobs.size }, "Expected job to be queued" do
      subject.destroy!
    end
  end
end
