# frozen_string_literal: true

module Types
  class RevenueType < Types::BaseObject
    field :id, ID, null: false
    field :value, Float
    field :concept, String
    field :category, Integer
    field :budget_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :budget, Types::BudgetType, null: false
  end
end
