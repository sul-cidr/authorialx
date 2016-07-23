# == Schema Information
#
# Table name: authors
#
#  author_id  :integer          not null, primary key
#  prefname   :string
#  label      :string
#  surname    :string
#  middle     :string
#  given      :string
#  birth_date :date
#  death_date :date
#  birth_year :integer
#  death_year :integer
#  viaf_id    :integer
#  wiki_id    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
