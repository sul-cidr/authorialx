json.array! @placerefs do |place|
  json.placeref place
  json.work place.work
  json.author place.author

end
  # json.extract!(
  #   place,
  #   :placeref_id,
  #   :placeref_type,
  #   :placeref,
  #   :author_id,
  #   :work_id,
  #   :place_id,
  #   :geom_wkt,
  #   :work
  # )
