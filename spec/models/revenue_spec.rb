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
require 'rails_helper'

RSpec.describe Revenue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
