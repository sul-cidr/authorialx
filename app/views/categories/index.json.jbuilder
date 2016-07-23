json.array! @categories do |category|
  json.category category
  json.dimension category.dimension.name


end
