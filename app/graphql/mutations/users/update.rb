# frozen_string_literal: true

module Mutations
  module Users
    class Update < BaseMutation
      field :user, Types::UserType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        user = User.find_by(id: id)
        user&.update!(params)

        { user: user }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
