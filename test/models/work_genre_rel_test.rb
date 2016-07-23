# == Schema Information
#
# Table name: work_genre_rels
#
#  id         :integer          not null, primary key
#  work_id    :integer
#  genre_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class WorkGenreRelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
