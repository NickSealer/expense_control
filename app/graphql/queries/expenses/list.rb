# frozen_string_literal: true

module Queries
  module Expenses
    class List < Queries::Base
      type [Types::ExpenseType], null: false

      def resolve
        Expense.all
      end
    end
  end
end
