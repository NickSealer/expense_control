# frozen_string_literal: true

module Mutations
  module Charges
    class Update < BaseMutation
      field :charge, Types::ChargeType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        charge = Charge.find_by(id: id)
        charge&.update!(params)

        { charge: charge }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
