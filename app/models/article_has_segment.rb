# frozen_string_literal: true

class ArticleHasSegment < ApplicationRecord
  belongs_to :article
  belongs_to :segment
end
