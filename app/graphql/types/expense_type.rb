# frozen_string_literal: true

module Types
  class ExpenseType < Types::BaseObject
    field :id, ID, null: false
    field :detail, String
    field :value, Float
    field :date, GraphQL::Types::ISO8601Date
    field :month, Integer
    field :year, Integer
    field :user_id, Integer
    field :category_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user, Types::UserType, null: false
    field :category, Types::CategoryType, null: false
  end
end
