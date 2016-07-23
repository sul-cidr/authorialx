# works but results nested in 'results'
json.array! @passages.hits do |hit|
  hit.highlights(:text).each do |highlight|
    # puts "  " + highlight.format { |word| "***#{word}***" }
    # json.hit hit.result
    json.highlight highlight.format { |word| "<hl>#{word}</hl>" }
    # json.text hit.result.text
  end
  json.passage_id hit.result.passage_id
  json.work_id hit.result.work_id
end
