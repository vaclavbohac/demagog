# frozen_string_literal: true

class MediaPersonality < ApplicationRecord
  has_and_belongs_to_many :media
  has_many :sources
  has_one :attachment
end
