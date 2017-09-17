class Speaker < ApplicationRecord
  has_many :parties, through: :membership
  has_many :statements
end
