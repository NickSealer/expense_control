# frozen_string_literal: true

module Mutations
  module Categories
    class Update < BaseMutation
      field :category, Types::CategoryType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        category = Category.find_by(id: id)
        category&.update!(params)

        { category: category }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
