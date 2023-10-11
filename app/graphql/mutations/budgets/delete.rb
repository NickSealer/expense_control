# frozen_string_literal: true

module Mutations
  module Budgets
    class Delete < BaseMutation
      field :budget, Types::BudgetType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        budget = current_user.budgets.find_by(id: id)
        budget&.destroy

        { budget: budget }
      end
    end
  end
end
