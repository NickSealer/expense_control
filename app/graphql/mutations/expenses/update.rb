# frozen_string_literal: true

module Mutations
  module Expenses
    class Update < BaseMutation
      field :expense, Types::ExpenseType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        expense = current_user.expenses.find_by(id: id)
        expense&.update!(params)

        { expense: expense }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
