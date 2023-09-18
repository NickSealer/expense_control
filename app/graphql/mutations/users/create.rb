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
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
