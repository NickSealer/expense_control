# frozen_string_literal: true

module ApplicationHelper
  def select_category_options(user_id, selected_value)
    options ||= Category.where(user_id: user_id).order(:name).map { |category| [category.name, category.id] }
    options_for_select options, selected_value
  end

  def total_current_month(current_user)
    "#{Date::MONTHNAMES[Time.now.month]}: #{number_to_currency(current_user.month_current_expenses)}"
  end
end
