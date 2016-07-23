# == Schema Information
#
# Table name: passages
#
#  passage_id :string           not null, primary key
#  work_id    :integer
#  subject_id :integer
#  text       :text
#  placerefs  :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Passage < ActiveRecord::Base
  self.primary_key = 'passage_id'

  def to_param
    passage_id
  end

  belongs_to :work, foreign_key: :work_id
  has_many :placerefs, foreign_key: :passage_id
  has_many :places, :through => :placerefs

  searchable do
    text :text, :stored => true

    string :passage_id, :stored => true
    integer :work_id

  end

end
