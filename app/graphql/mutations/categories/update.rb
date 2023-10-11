# frozen_string_literal: true

module Mutations
  module Categories
    class Update < BaseMutation
      field :category, Types::CategoryType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        category = current_user.categories.find_by(id: id)
        category&.update!(params)

        { category: category }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
