# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryDecorator, type: :decorator do
  let!(:parent) { FactoryBot.create(:category) }
  let!(:category) { FactoryBot.create(:category, user: parent.user, parent: parent) }
  let(:category_decorated) { category.decorate }

  describe 'category decorated' do
    it 'responds to .link_to_parent' do
      expect(category_decorated).to respond_to(:link_to_parent)
      expect(category_decorated.link_to_parent).to include("href=\"/categories/#{parent.id}\"")
    end

    it 'responds to .link_to_expenses' do
      expect(category_decorated).to respond_to(:link_to_expenses)
      expect(category_decorated.link_to_expenses).to include("href=\"/expenses?category=#{category.id}\"")
    end
  end

  describe 'category no decorated' do
    it 'does not respond to .link_to_parent' do
      expect(category).not_to respond_to(:link_to_parent)
    end

    it 'does not respond to .link_to_expenses' do
      expect(category).not_to respond_to(:link_to_expenses)
    end
  end
end
