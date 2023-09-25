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
class Notification < ApplicationRecord
  after_save :broadcast_count_notification
  after_destroy_commit :broadcast_count_notification, :add_last_notification
  after_create_commit :broadcast_create_notification
  after_update_commit -> { broadcast_replace_to(:notification_content, partial: 'notifications/notification') }
  after_destroy_commit -> { broadcast_remove_to(:notification_content) }

  belongs_to :user

  scope :unread, -> { where(read: false) }

  def read!
    update!(read: true, read_at: Time.zone.now)
  end

  private

  def broadcast_count_notification
    broadcast_replace_to(:notifications, target: 'notification_count', partial: 'notifications/count', locals: { user: user })
  end

  def broadcast_create_notification
    broadcast_prepend_to(:notification_content, target: "notification-content-#{user.id}", partial: 'notifications/notification')
  end

  def add_last_notification
    broadcast_append_to(
      :notification_content,
      target: "notification-content-#{user.id}",
      partial: 'notifications/notification',
      locals: { notification: user.notifications.order(id: :desc).limit(10).last }
    )
  end
end
