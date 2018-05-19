# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :createBody, Mutations::CreateBody
  field :updateBody, Mutations::UpdateBody
  field :deleteBody, Mutations::DeleteBody

  field :createSpeaker, Mutations::CreateSpeaker
  field :updateSpeaker, Mutations::UpdateSpeaker
  field :deleteSpeaker, Mutations::DeleteSpeaker
end
