# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesQuery, type: :service do
  let(:user) { FactoryBot.create(:user, :with_categories) }

  describe '.search' do
    context 'with results' do
      it 'returns category collection according the param' do
        expect(described_class.search(user, 'name')).to be_a(ActiveRecord::Relation)
        expect(described_class.search(user, 'name').size).to be > 0
        expect(described_class.search(user, 'name').first).to be_a(Category)
      end
    end

    context 'without results' do
      it 'returns an empty category collection' do
        expect(described_class.search(user, 'example')).to be_a(ActiveRecord::Relation)
        expect(described_class.search(user, 'example').size).to be == 0
      end
    end
  end
end
