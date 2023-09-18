# frozen_string_literal: true

module Mutations
  module Categories
    class Create < BaseMutation
      field :category, Types::CategoryType, null: false
      argument :params, Types::Inputs::Category, required: true

      def resolve(params:)
        category = Category.create!(Hash(params))

        { category: category }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
