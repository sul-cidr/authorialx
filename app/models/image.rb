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

class Image < ActiveRecord::Base

  # self.primary_key = 'image_id'

  has_many :author_image_rels
  has_many :authors, :through => :author_image_rels

end
