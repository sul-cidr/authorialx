class RemoveCategoriesFromAuthor < ActiveRecord::Migration
  def change
    remove_column :authors, :community_id, :integer
    remove_column :authors, :standing_id, :integer
  end
end
