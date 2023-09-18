# frozen_string_literal: true

module Types
  class BudgetType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer
    field :from_date, GraphQL::Types::ISO8601Date
    field :to_date, GraphQL::Types::ISO8601Date
    field :enable_dynamic_cash_flow, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :revenues, [Types::RevenueType], null: false
    field :charges, [Types::ChargeType], null: false
    field :user, Types::UserType, null: false
  end
end
