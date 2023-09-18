# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :description, String
    field :parent_id, Integer
    field :user_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :parent, Types::CategoryType, null: true
    field :children, [Types::CategoryType], null: true
    field :user, Types::UserType, null: false
    field :expenses, [Types::ExpenseType], null: true

    def parent
      object.parent
    end
  end
end
