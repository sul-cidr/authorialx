json.array! @works do |work|
  json.extract!(
    work,
    :work_id,
    :author_id,
    :title,
    :bio,
    :sorter,
    :work_year,
    :keywords
  )
end
