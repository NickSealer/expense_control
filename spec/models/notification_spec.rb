# frozen_string_literal: true

# == Schema Information
# Schema version: 20230823144307
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  message    :string
#  read       :boolean          default(FALSE)
#  read_at    :datetime
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { FactoryBot.build(:notification) }

  describe 'ActiveRecord associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'ActiveRecord indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'instance methods' do
    describe '.read' do
      it 'returns true' do
        notification.save
        notification.read!
        expect(notification.read).to be_truthy
      end
    end
  end

  describe 'broadcasting callbacks' do
    describe 'after_save' do
      it 'creates notification' do
        expect { notification.save }.to change(described_class, :count).by(1)
      end

      it 'broadcasting to notifications channel new count' do
        expect do
          notification.save
        end.to broadcast_to(:notifications)

        expect do
          notification.save
        end.to have_broadcasted_to(:notifications)

        expect do
          notification.save
        end.to have_broadcasted_to(:notifications).exactly(1)
      end
    end

    describe 'after_create_commit' do
      it 'creates notification' do
        expect { notification.save }.to change(described_class, :count).by(1)
      end

      it 'broadcasting to notifications and notification_content channel new notification' do
        expect do
          notification.save
        end.to broadcast_to(:notifications).and broadcast_to(:notification_content)

        expect do
          notification.save
        end.to have_broadcasted_to(:notifications).and have_broadcasted_to(:notification_content)

        expect do
          notification.save
        end.to have_broadcasted_to(:notifications).exactly(1).and have_broadcasted_to(:notification_content).exactly(1)
      end
    end

    describe 'after_update_commit' do
      before { notification.save }

      it 'updates notification as read' do
        expect(notification.read!).to be_truthy
      end

      it 'broadcasting to notifications and notification_content channel read notification' do
        expect do
          notification.read!
        end.to broadcast_to(:notifications).and broadcast_to(:notification_content)

        expect do
          notification.read!
        end.to have_broadcasted_to(:notifications).and have_broadcasted_to(:notification_content)

        expect do
          notification.read!
        end.to have_broadcasted_to(:notifications).exactly(1).and have_broadcasted_to(:notification_content).exactly(1)
      end
    end

    describe 'after_destroy_commit' do
      before { notification.save }

      it 'deletes the notification' do
        expect(described_class.count).to eq(1)
        expect { notification.destroy! }.to change(described_class, :count).by(-1)
      end

      it 'broadcasting to notifications and notification_content channel deleted notification' do
        expect do
          notification.destroy!
        end.to broadcast_to(:notifications).and broadcast_to(:notification_content)

        expect do
          notification.destroy!
        end.to have_broadcasted_to(:notifications).and have_broadcasted_to(:notification_content)

        expect do
          notification.destroy!
        end.to have_broadcasted_to(:notifications).exactly(1).and have_broadcasted_to(:notification_content).exactly(1)
      end
    end
  end
end
