# frozen_string_literal: true

# == Schema Information
# Schema version: 20230910011011
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  after_create_commit -> { broadcast_replace_to(:posts_channel, target: 'posts', partial: 'posts/count') }
  after_create_commit lambda {
                        broadcast_prepend_to(:table_posts_channel, target: 'broadcast_body',
                                                                   partial: 'posts/table_body')
                      }
  after_update_commit -> { broadcast_replace_to(:table_posts_channel, partial: 'posts/table_body') }
  after_destroy_commit -> { broadcast_remove_to(:table_posts_channel) }
end
