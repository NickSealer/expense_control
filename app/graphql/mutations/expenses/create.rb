# frozen_string_literal: true

module Mutations
  module Expenses
    class Create < BaseMutation
      field :expense, Types::ExpenseType, null: false
      argument :params, Types::Inputs::Expense, required: true

      def resolve(params:)
        expense = current_user.expenses.create!(Hash(params))

        { expense: expense }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
