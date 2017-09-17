class Medium < ApplicationRecord
  has_many :sources
  has_many_and_belongs_to :media_personalities
end
