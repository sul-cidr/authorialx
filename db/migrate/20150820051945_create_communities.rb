class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities, {:id => false} do |t|
      t.integer :community_id
			t.string :name
      t.integer :start_earliest
      t.integer :start_latest
      t.integer :stop_earliest
      t.integer :stop_latest
      t.timestamps null: false
    end
  end
end
