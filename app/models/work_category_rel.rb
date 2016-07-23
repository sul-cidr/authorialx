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

class WorkCategoryRel < ActiveRecord::Base
  belongs_to :work, :foreign_key => "work_id"
  belongs_to :category, :foreign_key => "category_id"

  accepts_nested_attributes_for :work
  accepts_nested_attributes_for :category
end
