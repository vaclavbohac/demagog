class ArticleHasSegment < ApplicationRecord
  belongs_to :article
  belongs_to :segment
end
