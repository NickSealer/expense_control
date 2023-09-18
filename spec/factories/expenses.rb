# frozen_string_literal: true

# == Schema Information
# Schema version: 20221012174735
#
# Table name: expenses
#
#  id          :bigint           not null, primary key
#  date        :date
#  detail      :string
#  month       :integer
#  value       :decimal(, )
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_expenses_on_category_id  (category_id)
#  index_expenses_on_month        (month)
#  index_expenses_on_user_id      (user_id)
#  index_expenses_on_year         (year)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :expense do
    date { Date.current }
    detail { 'detail' }
    value { 100.0 }
    association :category
    association :user
  end
end
