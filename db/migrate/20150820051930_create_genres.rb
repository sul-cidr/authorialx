class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres, {:id => false} do |t|
      t.integer :genre_id
    	t.string :name
      t.timestamps null: false
    end

    execute "ALTER TABLE genres ADD PRIMARY KEY (genre_id);"
  end
end
