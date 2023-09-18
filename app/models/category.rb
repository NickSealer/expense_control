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
class Category < ApplicationRecord
  has_one_attached :avatar

  IMAGE_TYPES = ['.png', '.jpeg', '.jpg'].freeze

  belongs_to :user
  has_many :expenses, dependent: :destroy

  belongs_to :parent, class_name: Category.to_s, optional: true
  has_many :children, class_name: Category.to_s, foreign_key: 'parent_id', dependent: :destroy

  validates_presence_of :name, :description
  validates :name, length: { in: 3..30 }
  validates :name, length: { maximum: 30 }
end
