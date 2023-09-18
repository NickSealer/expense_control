# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesQuery, type: :service do
  let(:user) { FactoryBot.create(:user, :with_categories) }
  let(:expense) { FactoryBot.create(:expense, user: user, category: user.categories.first) }

  describe '.monthly_expenses' do
    context 'with results' do
      subject!(:monthly_expenses) { described_class.monthly_expenses(expense.year, expense.user) }

      it { is_expected.to be_a(ActiveRecord::Relation) }

      it 'returns expense collection' do
        expect(monthly_expenses.length).to be > 0
        expect(monthly_expenses.first).to be_a(Expense)
      end
    end

    context 'without results' do
      subject!(:monthly_expenses) { described_class.monthly_expenses(1900, user) }

      it 'returns an empty expense collection' do
        expect(monthly_expenses).to be_a(ActiveRecord::Relation)
        expect(monthly_expenses.length).to be == 0
      end
    end
  end

  describe '.yearly_expenses' do
    subject!(:yearly_expenses) { described_class.yearly_expenses(expense.user) }

    context 'with results' do
      it 'returns expense collection' do
        expect(yearly_expenses).to be_a(ActiveRecord::Relation)
        expect(yearly_expenses.length).to be > 0
        expect(yearly_expenses.first).to be_a(Expense)
      end
    end

    context 'without results' do
      subject!(:yearly_expenses) { described_class.yearly_expenses(user) }

      it 'returns an empty expense collection' do
        expect(yearly_expenses).to be_a(ActiveRecord::Relation)
        expect(yearly_expenses.length).to be == 0
      end
    end
  end

  describe '.search' do
    let(:with_query_and_category) { described_class.search(expense.user, expense.detail, expense.category) }
    let(:with_query) { described_class.search(expense.user, expense.detail) }
    let(:with_category) { described_class.search(expense.user, nil, expense.category) }

    context 'with results' do
      context 'with query and category' do
        it 'returns expense collection' do
          expect(with_query_and_category).to be_a(ActiveRecord::Relation)
          expect(with_query_and_category.length).to be > 0
          expect(with_query_and_category.first).to be_a(Expense)
        end
      end

      context 'with query' do
        it 'returns expense collection' do
          expect(with_query).to be_a(ActiveRecord::Relation)
          expect(with_query.length).to be > 0
          expect(with_query.first.detail).to eq(expense.detail)
        end
      end

      context 'with category' do
        it 'returns expense collection' do
          expect(with_category).to be_a(ActiveRecord::Relation)
          expect(with_category.length).to be > 0
          expect(with_category.first.category_id).to eq(expense.category_id)
        end
      end
    end

    context 'without results' do
      let!(:no_results) { described_class.search(user, 'example') }

      it 'returns an empty expense collection' do
        expect(no_results).to be_a(ActiveRecord::Relation)
        expect(no_results.length).to be == 0
      end
    end
  end
end
