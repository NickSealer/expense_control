# frozen_string_literal: true

module Types
  module Inputs
    class Category < Types::BaseInputObject
      argument :name, String, required: true
      argument :description, String, required: true
      argument :parent_id, ID, required: false
    end
  end
end
