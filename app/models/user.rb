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
class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  include GraphqlDevise::Authenticatable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_one_attached :avatar
  has_many :categories, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :revenues, through: :budgets
  has_many :charges, through: :budgets
  has_many :notifications, dependent: :destroy
  has_many :assistant_messages, dependent: :destroy

  validates :email, :password, presence: true, on: :create
  validates :email, uniqueness: true
  validate :password_complexity

  def month_current_expenses
    current_date ||= Time.now
    expenses.where(month: current_date.month, year: current_date.year).sum(:value)
  end

  def current_budget
    budgets.last
  end

  def unread_notification_count
    notifications.unread.count
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    user ||= User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20])
    user
  end

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{1,70}$/

    errors.add :password, 'is weak, please use a combination of characters: uppercase, lowercase, numbers, and symbols'
  end
end
