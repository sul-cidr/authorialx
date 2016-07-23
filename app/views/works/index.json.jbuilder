json.array! @works do |work|
  json.extract!(
    work,
    :work_id,
    :author_id,
    :title,
    :sorter,
    :work_year,
    :keywords
  )
end
