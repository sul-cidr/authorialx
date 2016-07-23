class CreateAuthorCategoryRels < ActiveRecord::Migration
  def change
    create_table :author_category_rels do |t|
      t.integer :author_id
      t.integer :category_id

      t.timestamps null: false

      t.index [:author_id, :category_id]
      t.index [:category_id, :author_id]

      t.timestamps null: false
    end
  end
end
