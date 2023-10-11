# frozen_string_literal: true

module Mutations
  module Categories
    class Create < BaseMutation
      field :category, Types::CategoryType, null: false
      argument :params, Types::Inputs::Category, required: true

      def resolve(params:)
        category = current_user.categories.create!(Hash(params))

        { category: category }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
