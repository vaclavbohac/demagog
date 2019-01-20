# frozen_string_literal: true

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "elasticsearch"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Enable factorybot
  include FactoryBot::Syntax::Methods

  setup do
    ensure_veracities
  end

  private
    def ensure_veracities
      [:true, :untrue, :misleading, :unverifiable].each { |key| create(key) }
    end

    def elasticsearch_setup
      url = ENV["CIRCLE_CI_ELASTICSEARCH_URI"] || "http://localhost:9250"
      Elasticsearch::Model.client = Elasticsearch::Client.new url: url, log: false
    end

    def elasticsearch_index(models)
      models.each do |model|
        model.__elasticsearch__.create_index!
        model.__elasticsearch__.import
      end

      # Let the elasticsearch server process the indexed documents
      Kernel.sleep(1)
    end

    def elasticsearch_cleanup(models)
      models.each do |model|
        model.__elasticsearch__.delete_index!
      end
    end
end
