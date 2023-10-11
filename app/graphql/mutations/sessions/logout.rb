# frozen_string_literal: true

module Mutations
  module Sessions
    class Logout < BaseMutation
      field :response, String, null: true
      argument :id, ID, required: true

      def resolve(id:)
        raise_user_error(id)

        current_user.tokens.delete(client)
        current_user.save!
        remove_resource

        { response: 'Session finished.' }
      end

      private

      def controller
        @controller ||= context[:controller]
      end

      def remove_resource
        controller.resource = nil
        controller.client_id = nil
        controller.token = nil
      end
    end
  end
end
