# frozen_string_literal: true

class WeeklyReportMailerJob
  include Sidekiq::Job
  sidekiq_options queue: 'mailers', retry: 2

  def perform(user_id)
    user = User.find_by(id: user_id)
    expenses = Expense.current_month(user.id)

    MailMailer.weekly_report(user, expenses, Date.today).deliver_now
  end
end
