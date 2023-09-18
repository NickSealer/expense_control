# frozen_string_literal: true

module Expenses
  class CreateExpensesFromCsv < ApplicationService
    require 'csv'

    def initialize(csv_file, user_id)
      @csv_file = csv_file
      @user_id = user_id
    end

    def execute
      csv_text = File.read(@csv_file.path)
      csv = CSV.parse(csv_text, headers: true, col_sep: ',')
      create_expense(csv)
    end

    private

    def create_expense(csv)
      expenses_count = 0
      csv.each do |expense_array|
        params = {}
        params[:detail] = expense_array[0]
        params[:value] = expense_array[1]
        params[:date] = expense_array[2]
        params[:category_id] = expense_array[3]
        params[:user_id] = @user_id
        Expenses::CreateExpense.execute(params)
        expenses_count += 1
      end

      expenses_count
    end
  end
end
