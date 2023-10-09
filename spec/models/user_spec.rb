# frozen_string_literal: true

# == Schema Information
# Schema version: 20231004164102
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(FALSE)
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :string
#  confirmation_token     :string
#  confirmed_at           :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  token                  :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_token                 (token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:invalid_user) { FactoryBot.build(:user, :invalid_user) }
  let(:access_token) { OpenStruct.new(info: { email: 'example@email.com', name: 'name' }.with_indifferent_access) }

  describe 'ActiveRecord associations' do
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:expenses) }
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'ActiveRecord indexes' do
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:reset_password_token).unique }
    it { is_expected.to have_db_index(:token).unique }
  end

  describe 'ActiveRecord validations' do
    context 'validates presence' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:password).on(:create) }
    end

    # context 'validates uniqueness' do
    # it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    # end

    context 'validates password complexity' do
      it 'returns password if is valid' do
        expect(user.errors.messages).not_to include(:password)
      end

      it 'adds error message if password is invalid' do
        invalid_user.valid?
        expect(invalid_user.errors.messages).to include(:password)
      end
    end
  end

  describe 'Class methods' do
    describe '.from_omniauth' do
      it 'returns an user' do
        expect(described_class.from_omniauth(access_token)).to be_a(described_class)
      end
    end
  end

  describe 'Instance methods' do
    describe '.month_current_expenses' do
      it 'returns the current value of the month' do
        expect(user.month_current_expenses).to be_a(Numeric)
      end
    end
  end
end
