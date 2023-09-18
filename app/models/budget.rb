# frozen_string_literal: true

# == Schema Information
# Schema version: 20230508145836
#
# Table name: budgets
#
#  id                       :bigint           not null, primary key
#  enable_dynamic_cash_flow :boolean          default(FALSE)
#  from_date                :date
#  to_date                  :date
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  user_id                  :bigint
#
# Indexes
#
#  index_budgets_on_user_id  (user_id)
#
class Budget < ApplicationRecord
  belongs_to :user
  has_many :revenues, dependent: :destroy
  has_many :charges, dependent: :destroy
  accepts_nested_attributes_for :revenues, allow_destroy: true
  accepts_nested_attributes_for :charges, allow_destroy: true

  validates_associated :revenues, :charges

  after_update :set_default_from_date, :set_default_to_date

  # Monthly
  def monthly_revenue
    revenues.sum(:value)
  end

  def monthly_charges
    charges.sum(:value)
  end

  def estimated_monthly_balance
    monthly_revenue - monthly_charges
  end

  # Annual
  def annual_revenue
    monthly_revenue * (12 - created_at.month)
  end

  def annual_charges
    monthly_charges * (12 - created_at.month)
  end

  def estimated_annual_balance
    estimated_monthly_balance * (12 - created_at.month)
  end

  private

  def set_default_from_date
    return unless from_date.nil?

    update_columns(from_date: created_at.to_date)
  end

  def set_default_to_date
    return unless to_date.nil?

    update_columns(to_date: created_at.end_of_year.to_date)
  end
end
