# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }
  let(:expense) { FactoryBot.create(:expense, user: user, category: category) }

  describe '.expense_create' do
    let(:expense_create) { described_class.expense_create(user, expense) }

    context 'render the headers' do
      it { expect(expense_create.to).to include(user.email) }
      it { expect(expense_create.from).to include(ENV['SMTP_FROM']) }
      it { expect(expense_create.subject).to eq("New expense created: #{expense.id}.") }
    end

    it 'sends the email' do
      expect { expense_create.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end

  describe '.category_create' do
    let(:category_create) { described_class.category_create(user, category) }

    context 'render the headers' do
      it { expect(category_create.to).to include(user.email) }
      it { expect(category_create.from).to include(ENV['SMTP_FROM']) }
      it { expect(category_create.subject).to eq("New category created: #{category.name}.") }
    end

    it 'sends the email' do
      expect { category_create.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end

  describe '.category_delete' do
    let(:category_delete) { described_class.category_delete(user, category) }

    context 'render the headers' do
      it { expect(category_delete.to).to include(user.email) }
      it { expect(category_delete.from).to include(ENV['SMTP_FROM']) }
      it { expect(category_delete.subject).to eq("Category deleted: #{category.name}.") }
    end

    it 'sends the email' do
      expect { category_delete.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end

  describe '.weekly_report' do
    let(:weekly_report) { described_class.weekly_report(user, user.expenses, Date.today) }

    context 'render the headers' do
      it { expect(weekly_report.to).to include(user.email) }
      it { expect(weekly_report.from).to include(ENV['SMTP_FROM']) }
      it { expect(weekly_report.subject).to include('Current expenses from') }
    end

    it 'send the email' do
      expect { weekly_report.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by 1
    end
  end
end
