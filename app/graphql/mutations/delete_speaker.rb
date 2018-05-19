# frozen_string_literal: true

Mutations::DeleteSpeaker = GraphQL::Field.define do
  name "DeleteSpeaker"
  type !types.Int
  description "Delete existing speaker"

  argument :id, !types.Int

  resolve -> (obj, args, ctx) {
    raise Errors::AuthenticationNeededError.new unless ctx[:current_user]

    # Olol
    begin
      # TODO: check if it destroys also all memberships and avatar
      Speaker.destroy(args[:id].to_i)
      202
    rescue
      202
    end
  }
end
