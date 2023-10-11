# frozen_string_literal: true

module Mutations
  module Budgets
    class Update < BaseMutation
      field :budget, Types::BudgetType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        budget = current_user.budgets.find_by(id: id)
        budget&.update!(params)

        { budget: budget }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
