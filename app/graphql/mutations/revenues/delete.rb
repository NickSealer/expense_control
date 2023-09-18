# frozen_string_literal: true

module Mutations
  module Revenues
    class Delete < BaseMutation
      field :revenue, Types::RevenueType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        revenue = Revenue.find_by(id: id)
        revenue&.destroy

        { revenue: revenue }
      end
    end
  end
end
