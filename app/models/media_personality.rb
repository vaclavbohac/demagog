class MediaPersonality < ApplicationRecord
  has_many_and_belongs_to :media
  has_many :sources
  has_one :attachment
end
