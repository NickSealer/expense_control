# frozen_string_literal: true

module Mutations
  module Expenses
    class Create < BaseMutation
      field :expense, Types::ExpenseType, null: false
      argument :params, Types::Inputs::Expense, required: true

      def resolve(params:)
        expense = Expense.create!(Hash(params))

        { expense: expense }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
