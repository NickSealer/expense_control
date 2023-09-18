# frozen_string_literal: true

module Mutations
  module Revenues
    class Update < BaseMutation
      field :revenue, Types::RevenueType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        revenue = Revenue.find_by(id: id)
        revenue&.update!(params)

        { revenue: revenue }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
