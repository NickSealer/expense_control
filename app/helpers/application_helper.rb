# frozen_string_literal: true

module ApplicationHelper
  def total_current_month(current_user)
    "#{Date::MONTHNAMES[Time.now.month]}: #{number_to_currency(current_user.month_current_expenses)}"
  end
end
