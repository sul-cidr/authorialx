class CreateWorkGenreRels < ActiveRecord::Migration
  def change
    create_table :work_genre_rels do |t|
      t.integer :work_id
      t.integer :genre_id
      
      t.timestamps null: false
    end
  end
end
