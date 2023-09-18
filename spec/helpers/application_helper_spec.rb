# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }

  describe '.select_category_options' do
    it 'returns the category' do
      expect(select_category_options(user.id, category)).to include(category.name)
      expect(select_category_options(user.id, category)).to include(category.id.to_s)
    end
  end

  describe '.total_current_month' do
    it 'returns the month and value as string' do
      expect(total_current_month(user)).to be_a(String)
      expect(total_current_month(user)).to include(Date::MONTHNAMES[Time.now.month])
    end
  end
end
