# == Schema Information
#
# Table name: author_image_rels
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AuthorImageRelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
