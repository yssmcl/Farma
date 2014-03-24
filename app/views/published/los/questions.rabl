attributes :id, :title, :content, :exp_variables, :many_answers, :eql_sinal

node :last_answer,
  if: lambda { |question| question.has_last_answer?(current_user)} do |question|
  la = question.last_answer(current_user).answer
  {
    id: la.id,
    response: la.response,
    attempt_number: la.attempt_number,
    correct: la.correct,
    tips: la.tips.as_json
  }
end
