ActiveAdmin.register Work do
  permit_params :work_id, :title, :sorter, :author_id, :work_year, :keywords

	config.sort_order = 'work_id_desc'
	# config.sort_order = 'author_id_asc_and_title_asc'

	index do
		column :work_id
		column :title, sortable: :sorter
		column :author, sortable: :author_id
		column :work_year

		actions
	end

	filter :author
	filter :title

  form do |f|
    f.inputs "Work" do
      f.input :author
      f.input :title
      f.input :sorter,   :hint => "Title without leading article(s)"
      f.input :work_year, :hint => "Year to be used for display & temporal ordering"
      f.input :keywords,
        :hint => 'accept default [[""]] or manually enter, e.g. [["MyPlacename",1],["Another",2]]'
    end

    actions
  end



  sidebar 'Categories', :only => :show do
    table_for work.categories do |t|
      t.column("id") { |category| category.category_id }
      t.column("name") { |category| category.name }
    end
  end

	sidebar 'Passages from this work', :only => :show do
    table_for Passage.joins(:work).where(:work_id => work.work_id) do |t|
      t.column("text") { |passage| passage.text }
    end
  end

end
