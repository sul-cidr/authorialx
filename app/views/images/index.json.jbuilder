json.array! @images do |image|
  json.extract!(
    image,
    :id,
    :filename,
    :label,
    :author_id,
    :placeref_id,
    :caption,
    :geom_wkt
  )
end


# json.array! @areas do |area|
#   json.extract!(
#     area,
#     :area_id,
#     :prefname,
#     :area_type,
#     :keywords,
#     :geom_point_wkt,
#     :geom_poly_wkt
#   )
# end
