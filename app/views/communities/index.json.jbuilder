json.array! @communities do |community|
  json.extract!(
    community,
    :community_id,
    :name
  )
end
