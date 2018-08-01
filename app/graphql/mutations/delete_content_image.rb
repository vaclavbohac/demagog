# frozen_string_literal: true

Mutations::DeleteContentImage = GraphQL::Field.define do
  name "DeleteContentImage"
  type !types.ID
  description "Delete existing content image"

  argument :id, !types.ID

  resolve -> (obj, args, ctx) {
    Utils::Auth.authenticate(ctx)
    Utils::Auth.authorize(ctx, ["images:delete"])

    id = args[:id].to_i

    begin
      ContentImage.update(id, deleted_at: Time.now)
      id
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError.new(e.to_s)
    end
  }
end
