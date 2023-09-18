# frozen_string_literal: true

# == Schema Information
# Schema version: 20230508145836
#
# Table name: charges
#
#  id         :bigint           not null, primary key
#  category   :integer          default("fixed")
#  concept    :string
#  date       :date
#  value      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  budget_id  :bigint
#
# Indexes
#
#  index_charges_on_budget_id  (budget_id)
#  index_charges_on_concept    (concept)
#
class Charge < ApplicationRecord
  belongs_to :budget
  has_many :financial_movements, as: :financiable

  enum category: { fixed: 0, variable: 1 }

  validates_presence_of :concept, :value
  validates :value, numericality: { greater_than: 0 }
  validates :date, presence: true, if: -> { variable? }
end
