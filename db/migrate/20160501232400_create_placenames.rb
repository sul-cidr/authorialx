class CreatePlacenames < ActiveRecord::Migration
  def up
    create_table :placenames, {:id => false}  do |t|
      t.integer :placename_id # FK -> placeref_id
      t.string :placename
      t.timestamps null: false
    end
    execute "ALTER TABLE placenames ADD PRIMARY KEY (placename_id);"
  end


  def down
    drop_table :placenames
  end
end
