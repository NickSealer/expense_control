# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expenses::CreateExpensesFromCsv, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, id: 1, user: user) }
  let(:csv_file) { fixture_file_upload('spec/fixtures/expenses_csv.csv', 'text/csv') }

  describe '.execute' do
    it 'create an expense' do
      allow(Expenses::CreateExpense).to receive(:execute)
      expect(described_class.execute(csv_file, category.user)).to be_truthy
      expect(Expenses::CreateExpense).to have_received(:execute)
    end
  end
end
