json.array! @forms do |form|
  json.extract!(
    form,
    :form_id,
    :name
  )
end
