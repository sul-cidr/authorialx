class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms, {:id => false} do |t|
      t.integer :form_id
    	t.string :name
      t.timestamps null: false
    end

    execute "ALTER TABLE forms ADD PRIMARY KEY (form_id);"
    
  end
end
