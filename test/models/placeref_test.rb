# == Schema Information
#
# Table name: placerefs
#
#  id            :integer          not null, primary key
#  placeref_id   :integer          not null
#  work_id       :integer
#  year          :integer
#  passage_id    :string           not null
#  placeref      :string
#  author_id     :integer
#  place_id      :integer
#  placeref_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class PlacerefTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
