# frozen_string_literal: true

class ElasticsearchWorker
  include Sidekiq::Worker

  def perform(model_name, operation, record_id)
    record = model_class[model_name.to_s.to_sym].find(record_id)

    case operation.to_s.to_sym
    when :index
      record.__elasticsearch__.index_document
    when :update
      record.__elasticsearch__.update_document
    when :destroy
      record.__elasticsearch__.delete_document
    end
  end

  def model_class
    {
      speaker: Speaker
    }
  end
end
