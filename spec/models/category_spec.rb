# frozen_string_literal: true

# == Schema Information
# Schema version: 20221012174735
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :integer
#  user_id     :bigint
#
# Indexes
#
#  index_categories_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'ActiveRecord associations' do
    it { is_expected.to have_one_attached(:avatar) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:expenses).dependent(:destroy) }
    it { is_expected.to belong_to(:parent).optional(true) }
    it { is_expected.to have_many(:children).with_foreign_key('parent_id').dependent(:destroy) }
  end

  describe 'ActiveRecord indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'ActiveRecord validations' do
    context 'validates presence' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:description) }
    end

    context 'validates length' do
      it { is_expected.to validate_length_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(30) }
      it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(30) }
    end
  end
end
