# == Schema Information
#
# Table name: placenames
#
#  placename_id :integer          not null, primary key
#  placename    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Placename < ActiveRecord::Base
  self.primary_key = 'placename_id'

  before_create :set_id

  def set_id
    if Placename.count > 0
      self.placename_id = Placename.maximum(:placename_id).next
    else
      self.placename_id = 50001
    end
  end

  belongs_to :placeref, :foreign_key => "placeref_id"


end
