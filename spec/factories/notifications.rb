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
FactoryBot.define do
  factory :notification do
    read { false }
  end
end
