# frozen_string_literal: true

module Types
  module Inputs
    class Budget < Types::BaseInputObject
      argument :from_date, GraphQL::Types::ISO8601Date, required: true
      argument :to_date, GraphQL::Types::ISO8601Date, required: true
      argument :enable_dynamic_cash_flow, Boolean, required: true
      argument :revenues, [Types::Inputs::Revenue], required: true
      argument :charges, [Types::Inputs::Charge], required: true
    end
  end
end
