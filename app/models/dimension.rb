# == Schema Information
#
# Table name: dimensions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Dimension < ActiveRecord::Base

  has_many :categories
  # has_and_belongs_to_many :authors, :join_table => "authors_dimensions"

end
