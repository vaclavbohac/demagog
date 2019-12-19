# frozen_string_literal: true

require "test_helper"
require "sidekiq/testing"


class ElasticsearchWorkerTest < ActiveSupport::TestCase
  MODELS = [Speaker]

  setup do
    elasticsearch_index MODELS
  end

  teardown do
    elasticsearch_cleanup MODELS
  end

  test "indexing new models" do
    speaker = create(:speaker)

    assert_changes -> { Speaker.search(speaker.first_name).size }, "Expected model to be indexed" do
      subject = ElasticsearchWorker.new
      subject.perform(:speaker, :index, speaker.id)

      Kernel.sleep(1)
    end
  end

  test "updating existing models" do
    speaker = create(:speaker)
    speaker.__elasticsearch__.index_document

    new_name = "Jimmy"

    assert_changes -> { Speaker.search(new_name).size }, "Expected model to be updated" do
      speaker.update_attribute :first_name, new_name

      subject = ElasticsearchWorker.new
      subject.perform(:speaker, :update, speaker.id)

      Kernel.sleep(1)
    end
  end

  test "deleting models" do
    speaker = create(:speaker)
    speaker.__elasticsearch__.index_document
    Kernel.sleep(1)

    assert_changes -> { Speaker.search(speaker.first_name).size }, "Expected model to be deleted" do
      subject = ElasticsearchWorker.new
      subject.perform(:speaker, :destroy, speaker.id)

      Kernel.sleep(1)
    end
  end
end
