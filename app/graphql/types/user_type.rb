# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :email, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :sign_in_count, Integer, null: false
    field :current_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :last_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :current_sign_in_ip, String
    field :last_sign_in_ip, String
    field :active, Boolean
    field :categories, [Types::CategoryType], null: false
    field :total_categories, Integer, null: false
    field :expenses, [Types::ExpenseType], null: true

    def total_categories
      object.categories.count
    end
  end
end
