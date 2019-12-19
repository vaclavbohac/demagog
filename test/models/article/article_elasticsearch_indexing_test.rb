# frozen_string_literal: true

require_relative "../elasticsearch_indexing_testcase"

class ArticleElasticsearchIndexingTest < ElasticsearchIndexingTestCase
  test "indexing document on create" do
    assert_indexing_job_queued(name: "article", operation: "index") do
      subject = build(:static)
      subject.save!
    end
  end

  test "indexing document on update" do
    subject = create(:static)

    assert_indexing_job_queued(name: "article", operation: "update") do
      subject.title = "Hello"
      subject.save!
    end
  end

  test "indexing document on discard" do
    subject = create(:static)

    assert_indexing_job_queued(name: "article", operation: "destroy") do
      subject.discard
    end
  end
end
