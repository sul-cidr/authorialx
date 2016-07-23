# == Schema Information
#
# Table name: author_communities
#
#  id           :integer          not null, primary key
#  author_id    :integer
#  community_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class AuthorCommunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
