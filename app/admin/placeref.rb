ActiveAdmin.register Placeref do
  permit_params :placeref_id, :placeref, :work_id, :author_id, :passage_id,
    :placeref_type, :place_id, :year

  config.sort_order = 'placeref'

  index do
    column 'placename_id', :placeref_id
    column 'place reference', :placeref
    column 'passage_id', :passage_id
    column 'type', :placeref_type
    column 'place_id', :place_id

    actions
  end

  form do |f|
    f.inputs "Placeref Details" do
      li "Have placename_id and place_id to hand"
      f.input :placeref_id, label: "placename_id"
      f.input :placeref, label: "placeref string"
      f.input :work_id, label: "work_id"
      f.input :year, label: "work year"
      f.input :author_id, label: "author_id"
      f.input :passage_id, label: "passage_id"
      f.input :placeref_type, label: "type ('work' or 'bio')"
      f.input :place_id, label: "place_id"
    end
    f.actions
  end

  filter :placeref, label: "place reference string"
  filter :passage_id, label: "passage_id"

end
