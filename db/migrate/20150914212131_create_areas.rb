# areas are boroughs, neighborhoods, (poss.) wards for navigating spatially

class CreateAreas < ActiveRecord::Migration
  def up
    create_table :areas, {:id => false} do |t|
      t.integer :area_id
      t.string :prefname
      t.string :area_type
      t.text :geom_poly_wkt
      t.text :geom_point_wkt
      t.jsonb :keywords
      # t.st_point :geom_point, srid:4326
      # t.st_polygon :geom_poly, srid:4326
      t.timestamps null: false
    end
    execute "ALTER TABLE areas ADD PRIMARY KEY (area_id);"

  end
  def down
    drop table :areas
  end

end
