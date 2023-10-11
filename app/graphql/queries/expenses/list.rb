# frozen_string_literal: true

module Queries
  module Expenses
    class List < Queries::Base
      type [Types::ExpenseType], null: false

      def resolve
        current_user.expenses
      end
    end
  end
end
