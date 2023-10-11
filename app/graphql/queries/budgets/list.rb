# frozen_string_literal: true

module Queries
  module Budgets
    class List < Queries::Base
      type [Types::BudgetType], null: false

      def resolve
        current_user.budgets
      end
    end
  end
end
