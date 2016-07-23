class CreateAuthorImageRels < ActiveRecord::Migration
  def change
    create_table :author_image_rels do |t|
      t.integer :author_id
      t.integer :image_id

      t.index [:author_id, :image_id]
      t.index [:image_id, :author_id]

      t.timestamps null: false
    end
  end
end
