# frozen_string_literal: true

# call via console: rake expenses:send_report
namespace :expenses do
  desc 'Send weekly reports to user about its expenses'
  task send_report: :environment do
    @users = User.all
    @users.each do |user|
      @expenses = Expense.where({ user_id: user.id, month: Date.today.month })
      MailMailer.weekly_report(user, @expenses, Date.today).deliver
    end
  end
end
