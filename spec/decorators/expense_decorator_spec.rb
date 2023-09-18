# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseDecorator, type: :decorator do
  let!(:expense) { FactoryBot.create(:expense) }
  let(:expense_decorated) { expense.decorate }

  describe 'expense decorated' do
    it 'responds to .format_date' do
      expect(expense_decorated).to respond_to(:format_date)
      expect(expense_decorated.format_date(expense_decorated.created_at)).to eq(expense.created_at.strftime('%F - %T'))
    end

    it 'responds to .link_to_category' do
      expect(expense_decorated).to respond_to(:link_to_category)
      expect(expense_decorated.link_to_category).to include("href=\"/categories/#{expense.category.id}")
    end

    it 'responds to .link_to_edit' do
      expect(expense_decorated).to respond_to(:link_to_edit)
      expect(expense_decorated.link_to_edit).to include("href=\"/expenses/#{expense.id}/edit")
    end

    it 'responds to .modal_button' do
      expect(expense_decorated).to respond_to(:modal_button)
      expect(expense_decorated.modal_button).to include('data-toggle="modal"')
    end
  end

  describe 'expense no decorated' do
    it 'does not respond to .format_date' do
      expect(expense).not_to respond_to(:format_date)
    end

    it 'does not respond to .link_to_category' do
      expect(expense).not_to respond_to(:link_to_category)
    end

    it 'does not respond to .link_to_edit' do
      expect(expense).not_to respond_to(:link_to_edit)
    end

    it 'does not respond to .modal_button' do
      expect(expense).not_to respond_to(:modal_button)
    end
  end
end
