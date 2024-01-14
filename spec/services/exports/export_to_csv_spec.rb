# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::ExportToCsv, type: :service do
  let(:expenses) { FactoryBot.create_list(:expense, 1) }

  describe '.execute' do
    it 'returns data as string' do
      expect(described_class.execute(expenses)).to be_a(String)
    end
  end
end
