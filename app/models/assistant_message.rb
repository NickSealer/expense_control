# frozen_string_literal: true

# == Schema Information
# Schema version: 20230926162631
#
# Table name: assistant_messages
#
#  id         :bigint           not null, primary key
#  message    :text             default("")
#  request    :text             default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_assistant_messages_on_user_id  (user_id)
#
class AssistantMessage < ApplicationRecord
  belongs_to :user

  after_update_commit :broadcast_updated

  scope :daily, -> { where(created_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day]) }

  private

  def broadcast_updated
    broadcast_replace_to(
      :chatbox_channel,
      target: "assistant_message_#{id}",
      partial: 'assistant_messages/message',
      locals: { message: self }
    )
  end
end
