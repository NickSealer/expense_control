# frozen_string_literal: true

module Types
  module Inputs
    class Charge < Types::BaseInputObject
      argument :budget_id, ID, required: true
      argument :value, Float, required: true
      argument :concept, String, required: true
      argument :category, Integer, required: true, validates: { inclusion: { in: [0] } }
    end
  end
end
