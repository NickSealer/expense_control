# frozen_string_literal: true

module Queries
  module Users
    class List < Queries::Base
      type [Types::UserType], null: false

      def resolve
        User.where(id: current_user.id)
      end
    end
  end
end
