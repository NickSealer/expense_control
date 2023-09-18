# frozen_string_literal: true

class CategoryDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def link_to_parent
    parent ? (link_to parent.name, category_path(parent)) : ''
  end

  def link_to_expenses
    link_to(expenses.size, expenses_path(category: id))
  end
end
