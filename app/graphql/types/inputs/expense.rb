# frozen_string_literal: true

module Types
  module Inputs
    class Expense < Types::BaseInputObject
      argument :detail, String, required: true
      argument :value, Float, required: true
      argument :date, GraphQL::Types::ISO8601Date, required: true
      argument :category_id, ID, required: true
      argument :user_id, ID, required: true
    end
  end
end
