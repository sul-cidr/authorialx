json.array! @authors do |author|
  json.extract!(
    author,
    :author_id,
    :prefname,
    :label,
    :surname,
    :viaf_id,
    :wiki_id,
    :birth_year,
    :death_year,
    :image_file_name
  )
end
