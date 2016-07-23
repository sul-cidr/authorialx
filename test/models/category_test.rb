# == Schema Information
#
# Table name: categories
#
#  category_id  :integer          not null, primary key
#  name         :string
#  dimension_id :integer
#  sort         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
