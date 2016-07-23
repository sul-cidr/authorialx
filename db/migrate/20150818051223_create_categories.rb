class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories, {:id => false} do |t|
      t.integer :category_id
    	t.string :name
      t.integer :dimension_id
      t.integer :sort

      t.timestamps null: false
    end

    execute "ALTER TABLE categories ADD PRIMARY KEY (category_id);"
  end
  def down
    drop_table :categories
  end
end
