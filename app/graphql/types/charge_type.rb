# frozen_string_literal: true

module Types
  class ChargeType < Types::BaseObject
    field :id, ID, null: false
    field :value, Float
    field :concept, String
    field :category, Integer
    field :date, GraphQL::Types::ISO8601Date
    field :budget_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :budget, Types::BudgetType, null: false
  end
end
