# frozen_string_literal: true

Mutations::DeleteBody = GraphQL::Field.define do
  name "DeleteBody"
  type !types.Int
  description "Delete existing body"

  argument :id, !types.Int

  resolve -> (obj, args, ctx) {
    raise Errors::AuthenticationNeededError.new unless ctx[:current_user]

    # Olol
    begin
      Body.destroy(args[:id].to_i)
      202
    rescue
      202
    end
  }
end
