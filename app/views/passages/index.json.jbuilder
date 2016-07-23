json.array! @passages do |passage|
  json.extract!(
    passage,
    :passage_id,
    :subject_id,
    :work_id,
    :text
  )
end
