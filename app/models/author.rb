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

class Author < ActiveRecord::Base

  self.primary_key = 'author_id'

  # auto_increment :author_id

  # comment before adding first seed
  before_create :set_id

  def set_id
    if Author.count > 0
      self.author_id = Author.maximum(:author_id).next
    else
      self.author_id = 10001
    end
  end

  has_many :works
  has_many :passages, :through => :works
  has_many :placerefs, :through => :passages
  has_many :places, :through => :passages

  has_many :author_category_rels
  has_many :categories, :through => :author_category_rels

  has_many :author_image_rels
  has_many :images, :through => :author_image_rels

  accepts_nested_attributes_for :categories
  accepts_nested_attributes_for :author_category_rels

  def to_s
    "#{prefname}"
  end

  has_attached_file :image, styles: { thumb: "90x90>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
