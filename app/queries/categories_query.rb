# frozen_string_literal: true

class CategoriesQuery
  class << self
    delegate :search, to: :new
  end

  def initialize(categories = Category.all.includes(:expenses))
    @categories = categories
  end

  def search(current_user, query)
    @categories.where("name ILIKE '%#{query}%'").where(user_id: current_user.id)
               .or(@categories.where("description ILIKE '%#{query}%'").where(user_id: current_user.id))
  end
end
