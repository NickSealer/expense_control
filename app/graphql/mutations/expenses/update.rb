# frozen_string_literal: true

module Mutations
  module Expenses
    class Update < BaseMutation
      field :expense, Types::ExpenseType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        expense = Expense.find_by(id: id)
        expense&.update!(params)

        { expense: expense }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
