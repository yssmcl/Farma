glue @answer do
  attributes :id, :response, :attempt_number, :correct
  node(:tips) {|answer| answer.tips.as_json}
end
