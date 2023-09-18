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
FactoryBot.define do
  factory :budget do
    user { nil }
  end
end
