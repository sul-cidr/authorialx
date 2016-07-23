# == Schema Information
#
# Table name: communities
#
#  community_id   :integer
#  name           :string
#  start_earliest :integer
#  start_latest   :integer
#  stop_earliest  :integer
#  stop_latest    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
