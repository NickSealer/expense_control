# frozen_string_literal: true

# == Schema Information
# Schema version: 20230508145836
#
# Table name: revenues
#
#  id         :bigint           not null, primary key
#  category   :integer          default("fixed")
#  concept    :string
#  value      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  budget_id  :bigint
#
# Indexes
#
#  index_revenues_on_budget_id  (budget_id)
#  index_revenues_on_concept    (concept)
#
class Revenue < ApplicationRecord
  belongs_to :budget
  has_many :financial_movements, as: :financiable

  enum category: { fixed: 0, variable: 1 }

  validates_presence_of :concept, :value
  validates :value, numericality: { greater_than: 0 }
end
