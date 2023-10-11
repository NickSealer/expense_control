# frozen_string_literal: true

module Mutations
  module Users
    class Create < BaseMutation
      field :user, Types::UserType, null: false
      argument :params, Types::Inputs::User, required: true

      def resolve(params:)
        user = User.create!(Hash(params))

        { user: user }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
