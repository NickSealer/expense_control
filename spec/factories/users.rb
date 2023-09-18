# frozen_string_literal: true

# == Schema Information
# Schema version: 20221014231928
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  token                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_token                 (token) UNIQUE
#

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    password { 'Password123?' }
    name { 'user name' }
  end

  trait :active do
    active { true }
  end

  trait :with_categories do
    after(:create) { |user| create_list(:category, 5, user: user) }
  end

  trait :invalid_user do
    password { 'password' }
  end
end
