# frozen_string_literal: true

module Shared
  extend ActiveSupport::Concern

  included do
    def client
      @client ||= context[:headers][:client]
    end

    def current_user
      @current_user ||= context[:current_resource]
    end

    private

    def raise_user_error(id)
      raise GraphQL::ExecutionError, 'User not found.' if current_user.nil?
      raise GraphQL::ExecutionError, 'User not logged in.' unless current_user.tokens[client] && client
      raise GraphQL::ExecutionError, 'Unauthorized action.' if current_user.id != id.to_i
    end

    def raise_graphql_mutation_error(err)
      raise GraphQL::ExecutionError, "Invalid attributes for #{err.record.class}: #{err.record.errors.full_messages.join(', ')}"
    end
  end
end
