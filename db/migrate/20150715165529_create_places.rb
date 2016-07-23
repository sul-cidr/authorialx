# a Place has a geometry, for 1..* placerefs
class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places, {:id => false} do |t|
    	t.integer :place_id
      t.string :place_type
      t.string :prefname
      t.float :latitude
      t.float :longitude
    	t.text :geom_wkt
    	t.text :geom_wkt_l
    	t.text :geom_wkt_a
      t.string :source
      t.integer :placerefs_count
     	t.timestamps null: false
    end

    execute "ALTER TABLE places ADD PRIMARY KEY (place_id);"

  end
end
