ActiveAdmin.register Author do
  permit_params :author_id, :prefname, :surname, :middle, :given,
    :label, :birth_date, :death_date, :birth_year, :death_year,
    :wiki_id, :viaf_id, :name, :category_id, :image

	config.sort_order = 'author_id_desc'
	# config.sort_order = 'surname_asc'

	index do
		column 'author_id', :author_id
		column 'last name', :surname
		column 'died', :death_year
		column 'full name', :prefname
		column 'VIAF id', :viaf_id

		actions
	end

	filter :prefname, label: 'full name'

  form do |f|
    f.inputs "Author" do
      f.input :prefname, label: "Full name"
      f.input :label,:hint => "for display, e.g. 'G. Eliot'"
      f.input :surname, :hint => "Needed for alphabetizing"
      f.input :middle
      f.input :given
      f.input :birth_year
      f.input :birth_date, :as => :datepicker,:hint => "type YYYY-MM-DD"
      f.input :death_year
      f.input :death_date, :as => :datepicker,:hint => "type YYYY-MM-DD"
      f.input :image, as: :file
      f.input :wiki_id, label: "Wikipedia page ID, e.g. 'T.s._eliot'"
      f.input :viaf_id
    end

    f.actions

  end

	sidebar 'Works by this Author', :only => :show do
    table_for Work.joins(:author).where(:author_id => author.author_id) do |t|
      t.column("Title") { |work| work.title
      	link_to work.title, admin_work_path(work) }
    end
  end

  sidebar 'Categories', :only => :show do
    table_for author.categories do |t|
      t.column("id") { |category| category.category_id }
      t.column("name") { |category| category.name }
    end
  end
end


# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
