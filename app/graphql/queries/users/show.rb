# frozen_string_literal: true

module Queries
  module Users
    class Show < Queries::Base
      type Types::UserType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        raise_user_error(id)
        current_user
      end
    end
  end
end
