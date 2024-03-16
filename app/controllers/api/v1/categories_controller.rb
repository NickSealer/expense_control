# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < Api::V1::ApplicationController
      before_action :authenticate_user!, except: :search

      def index
        categories ||= current_user.categories.order(id: :asc).paginate(page: params[:page] || 1)
        render_response(klass: Category.to_s, data: categories)
      end

      def show
        category ||= current_user.categories.find(params[:id])
        render_response(data: category)
      end

      def search
        categories ||= CategoriesQuery.search(current_user || User.first, params[:query]).paginate(page: params[:page] || 1)
        render_response(klass: Category.to_s, data: categories)
      end
    end
  end
end
