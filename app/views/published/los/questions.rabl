attributes :id, :title, :content, :exp_variables, :many_answers, :eql_sinal

node(:test) {|question| @user.name }

node :last_answer,
  if: lambda { |question| question.has_last_answer?(@user, @team)} do |question|
  la = question.last_answer(@user, @team).answer
  {
    id: la.id,
    response: la.response,
    attempt_number: la.attempt_number,
    correct: la.correct,
    tips: la.tips.as_json
  }
end
