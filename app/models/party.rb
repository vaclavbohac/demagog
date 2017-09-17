class Party < ApplicationRecord
  has_many :speakers, through: :membership
end
