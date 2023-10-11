# frozen_string_literal: true

module Mutations
  module Charges
    class Create < BaseMutation
      field :charge, Types::ChargeType, null: false
      argument :params, Types::Inputs::Charge, required: true

      def resolve(params:)
        charge = current_user.charges.create!(Hash(params))

        { charge: charge }
      rescue ActiveRecord::RecordInvalid => e
        raise_graphql_mutation_error(e)
      end
    end
  end
end
