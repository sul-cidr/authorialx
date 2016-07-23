# placeref = reference in text to a place
# fk place_id --> place.place_id
class CreatePlacerefs < ActiveRecord::Migration
  def up
    create_table :placerefs, {:id => false} do |t|
    	t.integer :placeref_id
      t.string :passage_id
    	t.string :placeref
      t.integer :place_id
      t.integer :work_id
      t.integer :year
      t.integer :author_id
      t.string :placeref_type
     	t.timestamps null: false
    end

    execute "ALTER TABLE placerefs ADD PRIMARY KEY (placeref_id, passage_id);"
  end

  def down
    drop_table :placerefs
  end
end
