# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field_class GraphqlDevise::Types::BaseField

    field :logout, mutation: Mutations::Sessions::Logout

    field :create_user, mutation: Mutations::Users::Create, authenticate: false
    field :update_user, mutation: Mutations::Users::Update
    field :delete_user, mutation: Mutations::Users::Delete

    field :create_category, mutation: Mutations::Categories::Create
    field :update_category, mutation: Mutations::Categories::Update
    field :delete_category, mutation: Mutations::Categories::Delete

    field :create_expense, mutation: Mutations::Expenses::Create
    field :update_expense, mutation: Mutations::Expenses::Update
    field :delete_expense, mutation: Mutations::Expenses::Delete

    field :create_budget, mutation: Mutations::Budgets::Create
    field :update_budget, mutation: Mutations::Budgets::Update
    field :delete_budget, mutation: Mutations::Budgets::Delete

    field :create_revenue, mutation: Mutations::Revenues::Create
    field :update_revenue, mutation: Mutations::Revenues::Update
    field :delete_revenue, mutation: Mutations::Revenues::Delete

    field :create_charge, mutation: Mutations::Charges::Create
    field :update_charge, mutation: Mutations::Charges::Update
    field :delete_charge, mutation: Mutations::Charges::Delete

    # NOTE: camel case:
    # field_camel_case, action: update
    # fieldCamelCase, action: create
    # query
    # mutation {
    #   fieldName(input: { id: 1 # id for update and delete (no params key)
    #     params: {
    #       field1: "value 1"
    #       field2: "value 2"
    #     }
    #   }){
    #       object {
    #         field1
    #         field2
    #       }
    #     }
    #   }
  end
end
