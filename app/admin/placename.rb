ActiveAdmin.register Placename do
  permit_params :placename_id, :placename

	index do
		column 'placename_id', :placename_id
		column 'placename string', :placename

		actions
	end

  form do |f|
    f.inputs "Placename" do
      # f.input :placename_id, label: "placename_id"
      f.input :placename, label: "placename string"
    end
    f.actions
  end

	filter :placename

	sidebar 'Passages with this Placename', :only => :show do
    table_for Placeref.joins(:placename).where(:placeref_id => placename.placename_id) do |t|
      t.column("") { |placeref| placeref.passage_id }
    end
  end

  # sidebar 'Passages from this work', :only => :show do
  #   table_for Passage.joins(:work).where(:work_id => work.work_id) do |t|
  #     t.column("text") { |passage| passage.text }
  #   end
  # end
end
