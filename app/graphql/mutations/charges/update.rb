# frozen_string_literal: true

module Mutations
  module Charges
    class Update < BaseMutation
      field :charge, Types::ChargeType, null: false
      argument :id, ID, required: true
      argument :params, GraphQL::Types::JSON, required: true

      def resolve(id:, params:)
        charge = current_user.charges.find_by(id: id)
        charge&.update!(params)

        { charge: charge }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
