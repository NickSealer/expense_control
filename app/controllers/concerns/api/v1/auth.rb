# frozen_string_literal: true

module Api
  module V1
    module Auth
      extend ActiveSupport::Concern

      included do
        def authenticate
          return render json: { error: 'Unauthorized' }, status: :unauthorized unless Rails.env.development?

          current_user
        rescue StandardError => e
          raise ActiveRecord::RecordNotFound(e)
        end

        private

        def current_user
          @current_user ||= User.first
        end
      end
    end
  end
end
