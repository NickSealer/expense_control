# frozen_string_literal: true

# == Schema Information
# Schema version: 20230926162631
#
# Table name: assistant_messages
#
#  id         :bigint           not null, primary key
#  message    :text
#  request    :text
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
end
