glue @retroaction do
  attributes :id, :response, :correct
  node(:tips) {|retroaction| @tips.as_json}
  node(:attempt_number) { session[:retroaction][@question_id] }
end
