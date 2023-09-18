# frozen_string_literal: true

module Expenses
  class CreateExpense < ApplicationService
    def initialize(params)
      @params = params
    end

    def execute
      expense = Expense.new
      expense.assign_attributes(expense_params)
      expense.save!
    rescue StandardError => e
      Rollbar.error(e)
    end

    private

    def expense_params
      {
        detail: @params[:detail],
        value: @params[:value],
        date: @params[:date],
        user_id: @params[:user_id],
        category_id: @params[:category_id]
      }
    end
  end
end
