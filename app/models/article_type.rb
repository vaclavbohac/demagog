# frozen_string_literal: true

class ArticleType < ApplicationRecord
  has_many :articles
end
