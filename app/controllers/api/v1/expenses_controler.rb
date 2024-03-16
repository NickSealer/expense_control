# frozen_string_literal: true

module Api
  module V1
    class ExpensesController < Api::V1::ApplicationController
      before_action :authenticate_user!

      def index
        expenses ||= current_user.expenses.order(created_at: :desc).paginate(page: params[:page] || 1)
        render_response(klass: Expense.to_s, data: expenses)
      end

      def show
        expense = current_user.expenses.find(params[:id])
        render_response(data: expense)
      end

      def search
        expenses ||= ExpensesQuery.search(current_user, params[:query], params[:category]).paginate(page: params[:page] || 1)
        render_response(klass: Expense.to_s, data: expenses)
      end
    end
  end
end
