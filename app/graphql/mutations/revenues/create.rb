# frozen_string_literal: true

module Mutations
  module Revenues
    class Create < BaseMutation
      field :revenue, Types::RevenueType, null: false
      argument :params, Types::Inputs::Revenue, required: true

      def resolve(params:)
        revenue = Revenue.create!(Hash(params))

        { revenue: revenue }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
