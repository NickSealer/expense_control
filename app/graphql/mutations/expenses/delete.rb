# frozen_string_literal: true

module Mutations
  module Expenses
    class Delete < BaseMutation
      field :expense, Types::ExpenseType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        expense = Expense.find_by(id: id)
        expense&.destroy

        { expense: expense }
      end
    end
  end
end
