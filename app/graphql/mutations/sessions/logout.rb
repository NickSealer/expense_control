# frozen_string_literal: true

module Mutations
  module Sessions
    class Logout < BaseMutation
      field :response, String, null: true
      argument :id, ID, required: true

      def resolve(id:)
        user = user(id)
        return { response: I18n.t('graphql_devise.user_not_found') } if user.nil?

        raise GraphQL::ExecutionError, I18n.t('graphql_devise.user_not_found') unless user.tokens[client] && client

        user.tokens.delete(client)
        user.save!
        remove_resource

        { response: 'Session finished.' }
      end

      private

      def controller
        @controller ||= context[:controller]
      end

      def client
        @client ||= context[:headers][:client]
      end

      def user(id)
        return nil unless context[:current_resource].id == id.to_i

        @user ||= context[:current_resource]
      end

      def remove_resource
        controller.resource = nil
        controller.client_id = nil
        controller.token = nil
      end
    end
  end
end
