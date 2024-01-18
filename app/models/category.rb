# frozen_string_literal: true

# == Schema Information
# Schema version: 20240116202853
#
# Table name: categories
#
#  id             :bigint           not null, primary key
#  color          :string           default("white")
#  description    :string
#  expenses_count :integer
#  name           :string
#  priority       :integer          default("standard")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#  user_id        :bigint
#
# Indexes
#
#  index_categories_on_user_id  (user_id)
#
class Category < ApplicationRecord
  has_one_attached :avatar

  IMAGE_TYPES = ['.png', '.jpeg', '.jpg'].freeze
  STANDARD_COLORS = %w[white dimgray darkslategray gray lightgray].freeze
  LOW_COLORS = %w[drakgreen olive darkolivegreen forestgreen green].freeze
  MEDIUM_COLORS = %w[darkorange goldenrod saddlebrown chocolate peru].freeze
  HIGHT_COLORS = %w[firebrick crimson indianred darksalmon lighcoral].freeze
  URGENT_COLORS = %w[red darkred tomato orangered coral].freeze

  belongs_to :user
  has_many :expenses, dependent: :destroy

  belongs_to :parent, class_name: Category.to_s, optional: true
  has_many :children, class_name: Category.to_s, foreign_key: 'parent_id', dependent: :destroy

  validates_presence_of :name, :description
  validates :name, length: { in: 3..30 }
  validates :name, length: { maximum: 30 }

  enum priority: { standard: 0, low: 1, medium: 2, hight: 3, urgent: 4 }

  def self.select_colors(priority)
    colors = {
      'low': Category::LOW_COLORS,
      'medium': Category::MEDIUM_COLORS,
      'hight': Category::HIGHT_COLORS,
      'urgent': Category::URGENT_COLORS
    }

    colors.fetch(priority&.to_sym, Category::STANDARD_COLORS)
  end
end
