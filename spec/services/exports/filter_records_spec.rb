# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::FilterRecords, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:categories) { [FactoryBot.create(:category, user: user)] }
  let(:expenses) { [FactoryBot.create(:expense, user: user, category: categories.first)] }

  describe '.execute' do
    let(:params) { { from_date: Time.zone.today, to_date: Time.zone.today } }

    context 'when the type is category' do
      it 'returns category collection' do
        params[:export_type] = 'category'
        expect(described_class.execute(categories.first.user, params).first).to be_a(Category)
        expect(described_class.execute(categories.first.user, params)).to be_a(ActiveRecord::AssociationRelation)
      end
    end

    context 'when the type is expense' do
      it 'returns expense collection' do
        params[:export_type] = 'expense'
        expect(described_class.execute(expenses.first.user, params).first).to be_a(Expense)
        expect(described_class.execute(expenses.first.user, params)).to be_a(ActiveRecord::AssociationRelation)
      end
    end

    context 'when the type is not a model' do
      it 'returns an empty array' do
        expect(described_class.execute(categories.first.user, params).first).to be_nil
        expect(described_class.execute(categories.first.user, params)).to be_a(Array)
      end
    end
  end
end
