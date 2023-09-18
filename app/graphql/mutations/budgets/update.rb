# frozen_string_literal: true

module Mutations
  module Budgets
    class Update < BaseMutation
      field :budget, Types::BudgetType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        budget = Budget.find_by(id: id)
        budget&.update!(params)

        { budget: budget }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
