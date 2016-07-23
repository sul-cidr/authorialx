ActiveAdmin.register Category do
  permit_params :category_id, :name, :dimension_id

  config.sort_order = 'category_id_asc'

  index do
    column 'category id', :category_id
    column 'name', :name
    column 'dimension', :dimension
    # column 'dimension', :dimension_id

    actions
  end

  form do |f|
    f.inputs 'Categories' do
      # f.input :category_id, label: "Category ID"
      f.input :name
      f.input :dimension_id, :hint => "for Works [1: genre; 2: form], for Authors [3: period; 4: standing]"
    end
    actions
  end

  filter :name
  # filter :dimension_id
  filter :dimension, collection: proc { Dimension.order(:name)}
end
