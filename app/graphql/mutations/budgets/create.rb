# frozen_string_literal: true

module Mutations
  module Budgets
    class Create < BaseMutation
      field :budget, Types::BudgetType, null: false
      argument :params, Types::Inputs::Budget, required: true

      def resolve(params:)
        params = Hash params
        revenues = params[:revenues]
        charges = params[:charges]
        params.delete(:revenues)
        params.delete(:charges)

        budget = Budget.create!(Hash(params))
        budget.revenues.create!(revenues)
        budget.charges.create!(charges)

        { budget: budget }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
