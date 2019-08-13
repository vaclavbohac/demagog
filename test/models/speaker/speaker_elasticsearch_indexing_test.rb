# frozen_string_literal: true

require_relative "../elasticsearch_indexing_testcase"

class SpeakerElasticsearchIndexingTest < ElasticsearchIndexingTestCase
  test "indexing document on create" do
    assert_indexing_job_queued(name: "speaker", operation: "index") do
      subject = Speaker.new
      subject.save!
    end
  end

  test "indexing document on update" do
    subject = create(:speaker)

    assert_indexing_job_queued(name: "speaker", operation: "update") do
      subject.first_name = "Jimmy"
      subject.save!
    end
  end

  test "indexing document on destroy" do
    subject = create(:speaker)

    assert_indexing_job_queued(name: "speaker", operation: "destroy") do
      subject.destroy!
    end
  end
end
