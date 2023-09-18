# frozen_string_literal: true

module Mutations
  module Charges
    class Delete < BaseMutation
      field :charge, Types::ChargeType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        charge = Charge.find_by(id: id)
        charge&.destroy

        { charge: charge }
      end
    end
  end
end
