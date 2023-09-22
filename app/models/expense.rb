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
class Expense < ApplicationRecord
  before_save :set_year, :set_month
  after_create :create_notification

  IMAGE_TYPES = ['.png', '.jpeg', '.jpg'].freeze

  belongs_to :user
  belongs_to :category, counter_cache: true
  has_one_attached :avatar

  validates_presence_of :detail, :value, :date, :category_id
  validates :detail, length: { in: 4..60 }

  scope :current_year, -> { where(year: Time.now.year).order(created_at: :desc) }
  scope :current_month, lambda { |user_id, date = Time.zone.now|
    where(user_id: user_id, month: date.month, year: date.year).order(:date)
  }

  scope :monthly_detail_expenses, lambda { |month, user, year|
                                    where({ month: month, user_id: user, year: year }).order(:date)
                                  }

  scope :yearly_detail_expenses, lambda { |year, user|
    where({ year: year, user_id: user }).order(:date)
  }

  private

  def set_year
    self.year = date.year
  end

  def set_month
    self.month = date.month
  end

  def create_notification
    Notification.create!(
      message: "New Expense #{detail} created!",
      url: Rails.application.routes.url_helpers.expense_url(self, host: ENV['APP_HOST'], port: ENV['APP_PORT']),
      user_id: user_id
    )
  end
end
