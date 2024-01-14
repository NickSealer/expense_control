# frozen_string_literal: true

class ExpensesController < ApplicationController
  require 'csv'

  include AvatarConcern

  before_action :authenticate_user!
  before_action :expense, only: %i[show edit update]
  before_action :avatar, only: %i[create update]

  def index
    @expenses = if params[:search].present? || params[:category].present?
                  @category = params[:category].presence
                  ExpensesQuery.search(current_user, params[:search], params[:category]).decorate
                else
                  current_user.expenses.current_year.joins(:category).includes(:category).decorate
                end
  end

  def new
    @expense ||= current_user.expenses.new
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    attach_avatar(@expense)
    return render :new unless @expense.save

    redirect_to @expense, notice: 'Expense was successfully created.'
  end

  def update
    attach_avatar(expense)
    return render :edit unless expense.update(expense_params)

    redirect_to expense, notice: 'Expense was successfully updated.'
  end

  def summary
    @expenses ||= if params[:all_years].present?
                    ExpensesQuery.yearly_expenses(current_user)
                  else
                    ExpensesQuery.monthly_expenses(params[:year], current_user)
                  end
  end

  def summary_details
    @expenses ||= if !params[:month].present? && params[:year].present?
                    Expense.yearly_detail_expenses(params[:year], current_user.id)
                  elsif params[:month].present? && params[:year].present?
                    Expense.monthly_detail_expenses(params[:month], current_user.id, params[:year])
                  end

    respond_to do |format|
      format.html
      format.pdf { render template: 'expenses/summary', pdf: 'Sumary', layout: 'pdf', header: { right: '[page] of [topage]' } }
    end
  end

  def import_csv
    csv_file = params[:csv_file]
    return unless csv_file.present? && File.extname(csv_file.original_filename) == '.csv'

    expenses_loaded = Expenses::CreateExpensesFromCsv.execute(csv_file, current_user.id)
    redirect_to expenses_url, notice: "#{expenses_loaded} expenses loaded"
  end

  def download_csv
    layout = CSV.generate do |csv|
      csv << %w[detail value date category_id]
    end
    respond_to do |format|
      format.csv { send_data layout, filename: "Upload-expenses-#{Date.today}.csv" }
    end
  end

  def send_monthly_report
    success = Expenses::MonthlyReport.execute(current_user)
    redirect_to request.referer, notice: success ? 'Report sent!' : 'No Expenses found!'
  end

  private

  def expense
    @expense ||= current_user.expenses.find(params[:id]).decorate
  end

  def avatar
    @avatar = params[:expense][:avatar]
  end

  def expense_params
    params.require(:expense).permit(:detail, :value, :date, :category_id, :user_id)
  end
end
