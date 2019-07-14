# frozen_string_literal: true

require "active_support/concern"
require "elasticsearch/model"

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "#{self.model_name.collection}_#{Rails.env}"

    settings index: {
      analysis: {
        analyzer: {
          # Czech analyzer based on https://www.ludekvesely.cz/serial-elasticsearch-4-fulltextove-vyhledavani-v-cestine/
          czech: {
            type: "custom",
            tokenizer: "standard",
            filter: [
              "czech_stop",
              "czech_stemmer",
              "lowercase",
              "czech_stop",
              "asciifolding",
              "unique_on_same_position"
            ],
          }
        },
        filter: {
          czech_stemmer: {
            type: "stemmer",
            name: "czech"
          },
          czech_stop: {
            type: "stop",
            stopwords: ["_czech_"]
          },
          czech_length: {
            type: "length",
            min: 2
          },
          unique_on_same_position: {
            type: "unique",
            only_on_same_positon: true
          }
        },
      }
    }
  end
end
