# frozen_string_literal: true

class ExpensesQuery
  class << self
    delegate :monthly_expenses, :yearly_expenses, :search, to: :new
  end

  def initialize(expenses = Expense.all)
    @expenses = expenses
  end

  def monthly_expenses(year, current_user)
    @expenses.where(year: year, user_id: current_user.id)
             .select('COUNT(*) AS quantity, SUM(expenses.value) AS total_value, expenses.month, expenses.year')
             .group(:year, :month).order(:month)
  end

  def yearly_expenses(current_user)
    @expenses.where(user_id: current_user.id)
             .select('COUNT(*) AS quantity, SUM(expenses.value) AS total_year, expenses.year')
             .group(:year).order(:year)
  end

  def search(current_user, query = nil, category = nil)
    query_base = current_user.expenses.includes(:category)
    results = if query.present? && category.present?
                query_base.where('detail ILIKE ?', "%#{query}%").where(category_id: category)
              elsif query.present?
                query_base.where('detail ILIKE ?', "%#{query}%").or(query_base.where(year: query.to_i))
              elsif category.present?
                query_base.where(category_id: category)
              end
    results&.order(created_at: :desc)
  end
end
