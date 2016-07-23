# == Schema Information
#
# Table name: images
#
#  id          :integer          not null, primary key
#  image_id    :integer
#  filename    :string
#  place_id    :integer
#  author_id   :integer
#  placeref_id :integer
#  label       :string
#  caption     :text
#  geom_wkt    :text
#  latitude    :float
#  longitude   :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
