# frozen_string_literal: true

class Article < ApplicationRecord
  belongs_to :article_type
  belongs_to :source, optional: true
  belongs_to :user, optional: true
  belongs_to :illustration, class_name: "Attachment"
  belongs_to :document, class_name: "Attachment", optional: true
  has_many :article_has_segments
  has_many :segments, through: :article_has_segments

  def author
    self.user
  end
end
