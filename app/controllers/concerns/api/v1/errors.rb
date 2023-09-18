# frozen_string_literal: true

module Api
  module V1
    module Errors
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound do |e|
          render json: { error: e.message }, status: :not_found
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          render json: { error: e.message }, status: :unprocessable_entity
        end

        rescue_from Exception do |e|
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end
end
