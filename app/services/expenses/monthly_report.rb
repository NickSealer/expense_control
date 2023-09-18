# frozen_string_literal: true

module Expenses
  class MonthlyReport < ApplicationService
    def initialize(user)
      @user = user
    end

    def execute
      WeeklyReportMailerJob.perform_async(@user.id)
    end
  end
end
