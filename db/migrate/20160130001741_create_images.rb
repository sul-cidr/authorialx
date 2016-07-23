class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
    # create_table :images, {:id => false} do |t|
      t.integer :image_id
      t.string :filename
      t.integer :place_id
      t.integer :author_id
      t.integer :placeref_id
      t.string :label
      t.text :caption
      t.text :geom_wkt
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end

    # execute "ALTER TABLE images ADD PRIMARY KEY (image_id);"

  end
  def down
    drop_table :images
  end
end
