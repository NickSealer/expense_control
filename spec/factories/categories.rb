# frozen_string_literal: true

# == Schema Information
# Schema version: 20240116202853
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  color          :string           default("white")
#  description    :string
#  expenses_count :integer
#  name           :string
#  priority       :integer          default("standard")
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
