# frozen_string_literal: true

class MailMailer < ApplicationMailer
  def expense_create(user, expense)
    @expense = expense
    @user = user
    mail(to: @user.email, subject: "New expense created: #{@expense.id}.")
  end

  def category_create(user, category)
    @category = category
    @user = user
    mail(to: @user.email, subject: "New category created: #{@category.name}.")
  end

  def category_delete(user, category)
    @category = category
    @user = user
    mail(to: @user.email, subject: "Category deleted: #{@category.name}.")
  end

  def weekly_report(user, expenses, date)
    @expenses = expenses
    @month_name = Date::MONTHNAMES[date.month]
    @date = date
    mail(to: user.email, subject: "Current expenses from #{@month_name}")
  end
end
