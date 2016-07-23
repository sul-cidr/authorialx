json.array! @places do |place|

  json.place place[:place]
  json.count place[:count]
  json.biocount place[:biocount]

  # json.extract!(
  #   place,
  #   :place_id,
  #   :prefname
  #   # :geom_wkt,
  #   # :placerefs_count
  # )
end
