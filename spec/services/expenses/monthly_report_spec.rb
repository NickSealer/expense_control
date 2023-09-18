# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expenses::MonthlyReport, type: :service do
  let(:user) { FactoryBot.create(:user) }

  describe '.execute' do
    it 'enqueue the email to the sidekiq job' do
      allow(WeeklyReportMailerJob).to receive(:perform_async).with(user.id)
      described_class.execute(user)
      expect(WeeklyReportMailerJob).to have_received(:perform_async).once
    end
  end
end
