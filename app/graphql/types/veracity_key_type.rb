# frozen_string_literal: true

Types::VeracityKeyType = GraphQL::ScalarType.define do
  name "VeracityKey"
  description "Assessment veracity – can be either true, untrue, misleading or unverifiable"

  KNOWN_TYPES = [
    Veracity::TRUE,
    Veracity::UNTRUE,
    Veracity::MISLEADING,
    Veracity::UNVERIFIABLE
  ]

  coerce_input ->(value, ctx) do
    unless KNOWN_TYPES.include?(value)
      raise GraphQL::CoercionError, "cannot coerce `#{value.inspect}` to veracity. \
Known values are true, untrue, misleading or unverifiable"
    end

    value
  end

  coerce_result ->(value, ctx) { value.to_s }
end
