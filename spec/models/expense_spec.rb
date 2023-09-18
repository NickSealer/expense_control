# frozen_string_literal: true

# == Schema Information
# Schema version: 20221012174735
#
# Table name: expenses
#
#  id          :bigint           not null, primary key
#  date        :date
#  detail      :string
#  month       :integer
#  value       :decimal(, )
#  year        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_expenses_on_category_id  (category_id)
#  index_expenses_on_month        (month)
#  index_expenses_on_user_id      (user_id)
#  index_expenses_on_year         (year)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }
  let(:expense) { FactoryBot.create(:expense, user: user, category: category) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'ActiveRecord indexes' do
    it { is_expected.to have_db_index(:category_id) }
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'ActiveRecord validations' do
    context 'validates presence' do
      it { is_expected.to validate_presence_of(:date) }
      it { is_expected.to validate_presence_of(:detail) }
      it { is_expected.to validate_presence_of(:value) }
      it { is_expected.to validate_presence_of(:category_id) }
    end

    context 'validates length' do
      it { is_expected.to validate_length_of(:detail) }
      it { is_expected.to validate_length_of(:detail).is_at_least(4).is_at_most(60) }
    end
  end

  describe 'Inatance methods' do
    describe '.set_year' do
      it 'returns the year' do
        expect(expense.year).to be_a(Integer)
      end
    end

    describe '.set_month' do
      it 'returns the month' do
        expect(expense.month).to be_a(Integer)
      end
    end
  end
end
