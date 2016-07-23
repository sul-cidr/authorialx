# == Schema Information
#
# Table name: author_category_rels
#
#  id          :integer          not null, primary key
#  author_id   :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AuthorCategoryRel < ActiveRecord::Base
  belongs_to :author, :foreign_key => "author_id"
  belongs_to :category, :foreign_key => "category_id"

  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :category

end
