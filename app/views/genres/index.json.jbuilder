json.array! @genres do |genre|
  json.extract!(
    genre,
    :genre_id,
    :name
  )
end
