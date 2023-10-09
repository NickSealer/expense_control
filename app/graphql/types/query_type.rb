# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field_class GraphqlDevise::Types::BaseField

    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :users, resolver: Queries::Users::List
    field :user, resolver: Queries::Users::Show

    field :categories, resolver: Queries::Categories::List
    field :category, resolver: Queries::Categories::Show

    field :expenses, resolver: Queries::Expenses::List
    field :expense, resolver: Queries::Expenses::Show

    field :budgets, resolver: Queries::Budgets::List
    field :budget, resolver: Queries::Budgets::Show

    # NOTE: camel case:
    # fieldCamelCase
    # query
    # {
    #   records { or to find = record(id: 1)
    #     field1
    #     field2
    #   }
    # }
  end
end
