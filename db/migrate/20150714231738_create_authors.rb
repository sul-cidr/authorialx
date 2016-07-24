class CreateAuthors < ActiveRecord::Migration
  def up
      create_table :authors, {:id => false} do |t|
      	t.integer :author_id
      	t.string :prefname #label
      	t.string :label # shorter label
      	t.string :surname
      	t.string :middle
      	t.string :given
      	t.date :birth_date
      	t.date :death_date
      	t.integer :birth_year
      	t.integer :death_year
      	t.integer :viaf_id
      	t.string :wiki_id
      	t.timestamps null: false
      end

      execute "ALTER TABLE authors ADD PRIMARY KEY (author_id);"
  end

  def down
      drop_table :authors
  end
end
