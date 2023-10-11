# frozen_string_literal: true

module Mutations
  module Users
    class Delete < BaseMutation
      field :user, Types::UserType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        raise_user_error(id)
        current_user&.destroy

        { user: current_user }
      end
    end
  end
end
