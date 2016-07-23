ActiveAdmin.register Passage do
  permit_params :passage_id, :work_id, :subject_id, :text

  index do
		column 'passage_id', :passage_id
    column 'work', :work
		column :text

		actions
	end

  form do |f|
    f.inputs "Passage" do
      f.input :work
      f.input :passage_id, label: "passage_id"
      f.input :text
      f.input :subject_id, label: "Subject (author id if Bio)", hint: "-1 if none"
    end
    f.actions
  end

	filter :work, collection: proc { Work.order(:title)}
	filter :text

end
