# frozen_string_literal: true

module Queries
  module Categories
    class List < Queries::Base
      type [Types::CategoryType], null: false

      def resolve
        current_user.categories
      end
    end
  end
end
