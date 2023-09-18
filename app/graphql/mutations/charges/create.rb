# frozen_string_literal: true

module Mutations
  module Charges
    class Create < BaseMutation
      field :charge, Types::ChargeType, null: false
      argument :params, Types::Inputs::Charge, required: true

      def resolve(params:)
        charge = Charge.create!(Hash(params))

        { charge: charge }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
