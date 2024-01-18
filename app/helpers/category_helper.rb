# frozen_string_literal: true

module CategoryHelper
  def select_category_priority_options(selected_value)
    options ||= Category.priorities.keys.map { |priority| [priority.humanize, priority] }
    options_for_select options, selected_value
  end

  def select_category_options(user_id, selected_value)
    options ||= Category.where(user_id: user_id).order(:name).map { |category| [category.name, category.id] }
    options_for_select options, selected_value
  end

  def select_category_colors_options(priority, selected_color)
    options = Category.select_colors(priority)
    options_for_select options, selected_color
  end
end
