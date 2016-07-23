# app/views/authors/show.json.jbuilder

# json.array! @placerefs do |place|
#   json.placeref place
#   json.work place.work
#   json.author place.author
#
#   # json.extract!(
#   #   place,
#   #   :placeref_id,
#   #   :placeref_type,
#   #   :placeref,
#   #   :author_id,
#   #   :work_id,
#   #   :place_id,
#   #   :geom_wkt,
#   #   :work
#   # )
# end

json.author do
  json.author_id
  json.prefname
  json.surname
  json.viaf_id
  json.wiki_id
  json.birth_year
  json.death_year
end
