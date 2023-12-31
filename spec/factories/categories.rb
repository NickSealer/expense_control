# frozen_string_literal: true

# == Schema Information
# Schema version: 20230922180137
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  description    :string
#  expenses_count :integer
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#  user_id        :bigint
#
# Indexes
#
#  index_categories_on_user_id  (user_id)
#

FactoryBot.define do
  factory :category do
    name { 'category name' }
    description { 'category description' }
    association :user
  end
end
