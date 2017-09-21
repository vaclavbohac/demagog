# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :article_type
  belongs_to :source
  belongs_to :user
  belongs_to :illustration_id, class_name: "Attachment"
  belongs_to :document_id, class_name: "Attachment"
  has_many :segments, through: ArticleHasSegment

  def author
    self.user
  end
end
