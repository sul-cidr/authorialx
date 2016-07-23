ActiveAdmin.register AuthorCategoryRel do
  permit_params :category_id, :author_id

  # config.sort_order = 'id_desc'
  # config.sort_order = 'author_id_asc'

  index do
    column 'author', :author, sortable: :author_id
    column 'category', :category, sortable: :category_id

    actions
  end

  form do |f|
    f.inputs "Author-Category" do
      f.input :author_id, as: :select, :collection =>
        Author.all.map{|a| ["#{a.prefname}", a.author_id]}
      # f.input :author_id, as: :select, collection: Author.select(:prefname).uniq
      f.input :category_id, as: :select, :collection =>
        Category.where("dimension_id > 2").map{|c| ["#{c.name}", c.category_id]}
    end
    actions
  end


  # filter :author
  filter :category, :collection =>
    Category.where("dimension_id > 2").map{|c| ["#{c.name}", c.category_id]}
end
