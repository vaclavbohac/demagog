# frozen_string_literal: true

class Article < ApplicationRecord
  extend FriendlyId

  belongs_to :article_type
  belongs_to :source, optional: true
  belongs_to :user, optional: true
  belongs_to :illustration, class_name: "Attachment", optional: true
  belongs_to :document, class_name: "Attachment", optional: true
  has_many :article_has_segments
  has_many :segments, through: :article_has_segments
  has_many :statements, through: :segments
  has_many :speakers, through: :statements
  has_many :attachments, through: :speakers

  friendly_id :title, use: :slugged

  def author
    self.user
  end

  def unique_speakers
    speakers.distinct
  end

  def self.cover_story
    find_by({ published: true }, { published_at: :desc })
  end
end
