glue @answer do
  attributes :id, :response, :attempt_number, :correct

  node(:created_at) {|answer| l answer.created_at}
  node(:tips) {|answer| answer.tips.as_json}
end
