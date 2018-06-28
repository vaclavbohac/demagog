# frozen_string_literal: true

Types::ArticleInputType = GraphQL::InputObjectType.define do
  name "ArticleInputType"

  argument :title, !types.String
  argument :perex, !types.String
  argument :slug, types.String
  argument :published, types.Boolean
  argument :published_at, types.String
  argument :segments, types[!Types::SegmentInputType]
end
