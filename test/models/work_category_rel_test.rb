# == Schema Information
#
# Table name: work_category_rels
#
#  id          :integer          not null, primary key
#  work_id     :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class WorkCategoryRelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
