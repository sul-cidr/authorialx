ActiveAdmin.register WorkCategoryRel do
  permit_params :category_id, :work_id

  # config.sort_order = 'work_id_asc'

  controller do
    def scoped_collection
      super.includes :work # prevents N+1 queries to your database
    end
  end

  index do
    column 'work', :work, sortable: :work_id
    column 'category', :category

    actions
  end

  form do |f|
    f.inputs "Work-Category" do
      f.input :work_id, as: :select, :collection =>
        Work.all.map{|w| ["#{w.title}", w.work_id]}
      f.input :category_id, as: :select, :collection =>
        Category.where("dimension_id < 3").map{|c| ["#{c.name}", c.category_id]}
    end

    actions
  end

  # filter :work
  filter :category, :collection =>
    Category.where("dimension_id < 3").map{|c| ["#{c.name}", c.category_id]}

end
