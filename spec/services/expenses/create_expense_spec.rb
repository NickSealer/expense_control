# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expenses::CreateExpense, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    { detail: 'detail',
      value: 100.0,
      date: Date.today,
      user_id: user.id,
      category_id: FactoryBot.create(:category, user: user).id }.with_indifferent_access
  end

  describe '.execute' do
    it 'returns true if is success' do
      expect(described_class.execute(params)).to be_truthy
    end

    it 'raises error to rollbar if is not success' do
      begin
        expect { described_class.execute({}) }.to
      rescue StandardError
        StandardError
      end
      allow(Rollbar).to receive(:error)
      described_class.execute({})
      expect(Rollbar).to have_received(:error)
    end
  end
end
