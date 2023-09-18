# frozen_string_literal: true

module Mutations
  module Users
    class Delete < BaseMutation
      field :user, Types::UserType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        user = User.find_by(id: id)
        user&.destroy

        { user: user }
      end
    end
  end
end
