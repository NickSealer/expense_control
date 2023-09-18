# frozen_string_literal: true

module Queries
  module Users
    class List < Queries::Base
      type [Types::UserType], null: false

      def resolve
        User.all
      end
    end
  end
end
