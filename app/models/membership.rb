class Membership < ApplicationRecord
  belongs_to :party
  belongs_to :speaker
end
