json.array! @standings do |standing|
  json.extract!(
    standing,
    :standing_id,
    :name
  )
end
