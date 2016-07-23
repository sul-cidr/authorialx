# == Schema Information
#
# Table name: author_image_rels
#
#  id         :integer          not null, primary key
#  author_id  :integer
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuthorImageRel < ActiveRecord::Base

  belongs_to :author, :foreign_key => "author_id"
  belongs_to :image, :foreign_key => "image_id"

end
