# frozen_string_literal: true

module Mutations
  module Users
    class Update < BaseMutation
      field :user, Types::UserType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        raise_user_error(id)
        current_user&.update!(params)

        { user: current_user }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
