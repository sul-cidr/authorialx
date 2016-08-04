class CreateWorks < ActiveRecord::Migration
  def up
    create_table :works, {:id => false} do |t|
    	t.integer :work_id
    	t.integer :author_id
      t.string :title
      t.string :sorter
    	t.integer :work_year
      t.boolean :bio
      t.jsonb :keywords
     	t.timestamps null: false
    end

    execute "ALTER TABLE works ADD PRIMARY KEY (work_id);"

  end

  def down
    drop_table :works
  end
end
