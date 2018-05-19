# frozen_string_literal: true

Mutations::UpdateSpeaker = GraphQL::Field.define do
  name "UpdateSpeaker"
  type Types::SpeakerType
  description "Update existing speaker"

  argument :id, !types.Int
  argument :body_input, !Types::SpeakerInputType

  resolve -> (obj, args, ctx) {
    raise Errors::AuthenticationNeededError.new unless ctx[:current_user]

    speaker = args[:speaker_input].to_h

    speaker["memberships"] = speaker["memberships"].map do |mem|
      membership = mem["id"] ? Membership.find(mem["id"]) : Membership.new()

      membership.assign_attributes(
        body: Body.find(mem["body_id"]),
        since: mem["since"],
        until: mem["until"]
      )

      membership
    end

    Speaker.transaction do
      speaker["memberships"].each do |mem|
        mem.save
      end

      Speaker.update(args[:id], speaker)
    end
  }
end
