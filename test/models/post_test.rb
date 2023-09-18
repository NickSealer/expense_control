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
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
