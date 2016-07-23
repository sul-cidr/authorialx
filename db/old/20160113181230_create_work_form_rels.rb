class CreateWorkFormRels < ActiveRecord::Migration
  def change
    create_table :work_form_rels do |t|
      t.integer :work_id
      t.integer :form_id
      
      t.timestamps null: false
    end
  end
end
