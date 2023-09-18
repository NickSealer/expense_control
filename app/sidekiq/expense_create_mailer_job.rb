# frozen_string_literal: true

class ExpenseCreateMailerJob
  include Sidekiq::Job
  sidekiq_options queue: 'mailers', retry: 2

  def perform(user_id, expense_id)
    user = User.find_by(id: user_id)
    expense = Expense.find_by(id: expense_id)

    MailMailer.expense_create(user, expense).deliver_now
  end
end
