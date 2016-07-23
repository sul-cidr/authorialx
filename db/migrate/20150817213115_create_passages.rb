class CreatePassages < ActiveRecord::Migration
  def up
    create_table :passages, {:id => false}  do |t|
    	t.string :passage_id
    	t.integer :work_id
      t.integer :subject_id
    	t.text :text
    	t.string :placerefs, array: true, default: []
     	t.timestamps null: false
    end

    execute "ALTER TABLE passages ADD PRIMARY KEY (passage_id);"

  end

  def down
    drop_table :passages
  end

end
