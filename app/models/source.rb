class Source < ApplicationRecord
  belongs_to :medium
  has_many :statements
  has_one :media_personality
end
