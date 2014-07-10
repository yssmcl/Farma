node(:completeness, :if => lambda { |e| ( not(@team.nil?) && @answer.correct? ) } ) do
  current_user.completeness_of(@team, @lo)
end

# Change for auto sequence
node(:next_page) { @sequence.next_page? }
node(:has_more_exercise) { @has_more_exercise }

glue @answer do
  attributes :id, :response, :attempt_number, :correct

  node(:created_at) {|answer| l answer.created_at}
  node(:tips) {|answer| answer.tips.as_json}
end
