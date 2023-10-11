# frozen_string_literal: true

module Mutations
  module Revenues
    class Update < BaseMutation
      field :revenue, Types::RevenueType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        revenue = current_user.revenues.find_by(id: id)
        revenue&.update!(params)

        { revenue: revenue }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
