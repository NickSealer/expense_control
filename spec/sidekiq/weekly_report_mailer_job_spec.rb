# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeeklyReportMailerJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '.perform' do
    it { is_expected.to be_processed_in :mailers }
    it { is_expected.to be_retryable 2 }

    it 'enqueues the sidekiq job' do
      described_class.perform_async(user.id)
      expect(described_class).to have_enqueued_sidekiq_job(user.id)
    end

    it 'sends the email' do
      # rubocop:disable RSpec/NamedSubject
      expect(subject.perform(user.id)).to be_a(Mail::Message)
      # rubocop:enable RSpec/NamedSubject
    end
  end
end
