# frozen_string_literal: true

module Queries
  module Expenses
    class Show < Queries::Base
      type Types::ExpenseType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        current_user.expenses.find_by(id: id)
      end
    end
  end
end
