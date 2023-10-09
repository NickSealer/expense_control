# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Api::V1::Errors

      before_action :authenticate_user!

      def render_response(klass: nil, data: nil, status: :ok)
        return render_no_content if status == :no_content
        return render_collection_response(klass, data, status) if data.respond_to?(:each)

        render_object_response(data, status)
      end

      private

      def render_no_content
        head :no_content
      end

      def render_collection_response(klass, data, status)
        render json: {
          status: status,
          data: "Api::V1::#{klass}Decorator".constantize.decorate(klass.constantize).collection(data),
          pagination: {
            current_page: data&.current_page,
            per_page: data&.per_page,
            total_entries: data&.total_entries,
            total_pages: data&.total_pages
          }
        }, status: status
      rescue StandardError => e
        Rails.logger.error(e)
      end

      def render_object_response(object, status)
        render json: {
          status: status,
          data: "Api::V1::#{object.class}Decorator".constantize.decorate(object).basic_info
        }, status: status
      rescue StandardError => e
        Rails.logger.error(e)
      end
    end
  end
end
