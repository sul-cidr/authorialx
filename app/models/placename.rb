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

  # after_initialize do
  #   if new_record?
  #     :set_id
  #   end
  # end

  before_create :set_id

  def set_id
    self.placename_id = Placename.maximum(:placename_id).next
  end

  belongs_to :placeref, :foreign_key => "placeref_id"


end
