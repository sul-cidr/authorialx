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

# reference in a work.passage to a place

class Placeref < ActiveRecord::Base
  self.primary_key = 'id'
  # self.primary_key = 'placeref_id'

  # auto-increment work_id
  before_create :set_id

  def set_id
    if placeref.count > 0
      self.placeref_id = Placeref.maximum(:placeref_id).next
    else
      self.placeref_id = 30001
    end
  end

  belongs_to :passage
  belongs_to :work
  belongs_to :author
  belongs_to :place, :counter_cache => true

  has_one :placename, :foreign_key => "placename_id"

  scope :for_popup, -> {
    includes {work}
    includes {author}
  }

  scope :by_place, -> (pid = nil) {
    where("place_id = ?", pid)
  }

  scope :by_place_and_authors, -> (pid = nil, authids = nil) {
    where(:place_id => pid, :author_id => authids)
  }

  scope :by_place_and_works, -> (pid = nil, workids = nil) {
    where(:place_id => pid, :work_id => workids)
  }

  scope :by_place_and_workcat, -> (pid = nil, workids = nil) {
    where(:place_id => pid, :work_id => workids)
  }


# CHECK: when is a place "in or near" an area/neighborhood
# approach #1: intersects a buffer around radius of area centroid
  # st_buffer( (st_geomfromtext(z.geom_point_wkt)), 0.01),
  # st_geomfromtext(z.geom_point_wkt),
# approach #2: intersects (within) area voronoi polygon
# below is #2
  def self.by_area(areaid)
    find_by_sql(
    "with z as (
    	select geom_poly_wkt from areas where area_id = "+ areaid.to_s +
    ")
    select pr.*
    	from z, placerefs pr join places p on pr.place_id=p.place_id
    	where st_intersects(
              st_geomfromtext(z.geom_poly_wkt),
              st_geomfromtext(p.geom_wkt)) AND
              pr.placeref_type = 'work'
            order by placeref, passage_id"
    )
  end

  def self.rank_places(params)
    refs = Placeref.all

    # agglomerates param terms
    if params[:work_cat]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:work_cat]}
    end
    if params[:auth_cat]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:auth_cat]}
    end

    if params[:author_id]
      refs = refs.joins{author}.where{author.author_id >> params[:author_id]}
    end

    if params[:authors] # array of author_id
      refs = refs.joins{author}.where{author.standing_id >> params[:authors]}
    end

    if params[:work_id]
      refs = refs.joins{work}.where{work.work_id >> params[:work_id]}
    end

    counts = {}

    refs.each do |ref|
      if !counts.has_key?(ref.place_id)
        counts[ref.place_id] = 1
      else
        counts[ref.place_id] += 1
      end
    end
    counts
  end

  def self.rank_bioplaces(params)
    refs = Placeref.where(placeref_type:'bio')
    # agglomerates param terms
    if params[:work_cat]
      refs = refs.joins{work.categories}.where{categories.category_id >> params[:work_cat]}
    end
    if params[:auth_cat]
      refs = refs.joins{author.categories}.where{categories.category_id >> params[:auth_cat]}
    end


    if params[:author_id]
      refs = refs.joins{author}.where{author.author_id >> params[:author_id]}
    end
    if params[:authors] # array of author_id
      refs = refs.joins{author}.where{author.standing_id >> params[:authors]}
    end

    if params[:work_id]
      refs = refs.joins{work}.where{work.work_id >> params[:work_id]}
    end

    biocounts = {}

    refs.each do |ref|
      if !biocounts.has_key?(ref.place_id)
        biocounts[ref.place_id] = 1
      else
        biocounts[ref.place_id] += 1
      end
    end
    biocounts
  end

end
