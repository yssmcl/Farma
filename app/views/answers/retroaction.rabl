#encoding: utf-8
glue @answer do
  attributes :id, :created_at, :response, :attempt_number

  # name can be show just for the user and the owner of team
  # node(:answered_by) { |answer| answer.user.name }
  node(:answered_by) { |answer| answer.can_see_user?(current_user) ? answer.user.name : 'Não identificado'}
  node(:created_at) { |answer| l answer.created_at }

  node(:lo)   {|answer| answer.lo.name}
  node(:team) {|answer| answer.team.name}

  child(:question) do
    attributes :id, :title, :content
  end

  child(:exercise) do 
    attributes :id, :title, :content

    child(:questions) do
      attributes :id, :title, :content, :exp_variables, :many_answers, :eql_sinal

      node(:answered) { |question| !question.soluction_id.nil? }

      node :last_answer,
        if: lambda { |question| question.last_answer } do |question|
        la = question.last_answer
        {
          id: la.id,
          response: la.response,
          attempt_number: la.attempt_number,
          correct: la.correct,
          tips: la.tips.as_json
        }
      end
    end
  end

  child(:comments) do
    attributes :id
    node(:can_destroy) { |comment| comment.can_destroy?(current_user) }
    node(:created_at_in_words) { |comment|  time_ago_in_words(comment.created_at) }
    node(:user_name) {|comment| comment.user.name }
    node(:user_gravatar) {|comment| comment.user.gravatar }
    node(:text) { |comment| markdown(comment.text) }
  end
end
