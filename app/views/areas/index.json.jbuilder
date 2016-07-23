json.array! @areas do |area|
  json.extract!(
    area,
    :area_id,
    :prefname,
    :area_type,
    :keywords,
    :geom_point_wkt,
    :geom_poly_wkt
  )
end
