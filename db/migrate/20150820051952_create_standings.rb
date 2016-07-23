class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings, {:id => false} do |t|
      t.integer :standing_id
    	t.string :name
      t.timestamps null: false
    end
  end
end
