# frozen_string_literal: true

Types::MembershipInputType = GraphQL::InputObjectType.define do
  name "MembershipInputType"

  argument :body, !types.Int
  argument :since, types.String
  argument :until, types.String
end
