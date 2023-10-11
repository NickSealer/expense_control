# frozen_string_literal: true

module Queries
  module Categories
    class Show < Queries::Base
      type Types::CategoryType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        current_user.categories.find_by(id: id)
      end
    end
  end
end
