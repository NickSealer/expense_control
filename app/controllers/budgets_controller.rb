# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :budget, :revenues, :charges, only: %i[show edit update destroy]

  def index
    @budgets ||= current_user.budgets
  end

  def new
    @budget ||= current_user.budgets.new
    @budget.revenues.new
    @budget.charges.new
  end

  def create
    @budget ||= current_user.budgets.create(budget_params)
    return render :new unless @budget.save

    redirect_to budgets_url, notice: 'Budget created!'
  end

  def update
    return render :edit unless budget.update!(budget_params)

    redirect_to budget, notice: 'Budget updated!'
  end

  def destroy
    budget.destroy! if budget.user == current_user
    redirect_to budgets_url, notice: 'Budget deleted!'
  end

  private

  def budget
    @budget ||= current_user.budgets.find(params[:id])
  end

  def revenues
    @revenues ||= budget.revenues
  end

  def charges
    @charges ||= budget.charges
  end

  def budget_params
    params.require(:budget).permit(
      :enable_dynamic_cash_flow,
      revenues_attributes: %i[id value concept category _destroy],
      charges_attributes: %i[id value concept date category _destroy]
    )
  end
end
