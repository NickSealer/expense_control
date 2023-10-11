# frozen_string_literal: true

module Mutations
  module Revenues
    class Create < BaseMutation
      field :revenue, Types::RevenueType, null: false
      argument :params, Types::Inputs::Revenue, required: true

      def resolve(params:)
        revenue = current_user.revenues.create!(Hash(params))

        { revenue: revenue }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
