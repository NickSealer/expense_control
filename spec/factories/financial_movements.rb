# frozen_string_literal: true

# == Schema Information
# Schema version: 20230508145836
#
# Table name: financial_movements
#
#  id               :bigint           not null, primary key
#  financiable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  financiable_id   :bigint
#
# Indexes
#
#  index_financial_moves_on_financiable_type_and_financiable_id  (financiable_type,financiable_id)
#
FactoryBot.define do
  factory :financial_movement do
  end
end
