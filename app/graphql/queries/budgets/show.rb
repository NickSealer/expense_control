# frozen_string_literal: true

module Queries
  module Budgets
    class Show < Queries::Base
      type Types::BudgetType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        current_user.budgets.find_by(id: id)
      end
    end
  end
end
