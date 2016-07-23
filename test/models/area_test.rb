# == Schema Information
#
# Table name: areas
#
#  area_id        :integer          not null, primary key
#  prefname       :string
#  area_type      :string
#  geom_poly_wkt  :text
#  geom_point_wkt :text
#  keywords       :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
