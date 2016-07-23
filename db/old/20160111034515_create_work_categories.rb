class CreateWorkCategories < ActiveRecord::Migration
  def change
    create_table :work_categories do |t|
      t.integer :work_id
    	t.integer :category_id

      t.timestamps null: false

      t.index [:work_id, :category_id]
      t.index [:category_id, :work_id]
    end
  end
end
