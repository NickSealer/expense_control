# frozen_string_literal: true

module Mutations
  module Categories
    class Delete < BaseMutation
      field :category, Types::CategoryType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        category = Category.find_by(id: id)
        category&.destroy

        { category: category }
      end
    end
  end
end
