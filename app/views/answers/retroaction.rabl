#encoding: utf-8
glue @answer do
  attributes :id, :created_at, :response, :try_number

  # name can be show just for the user and the owner of team
  #node(:answered_by) { |answer| answer.user.name }
  node(:answered_by) {|answer| answer.can_see_user?(current_user) ? answer.user.name : 'Não identificado'}
  node(:created_at) { |answer| l answer.created_at }

  node(:lo) {|answer| answer.lo.name}
  node(:team) {|answer| answer.team.name}
  node(:exercise) {|answer| answer.exercise_as_json}
  node(:question) {|answer| answer.question_as_json}

  child(:comments) do
    attributes :id
    node(:can_destroy) { |comment| comment.can_destroy?(current_user) }
    node(:created_at_in_words) { |comment|  time_ago_in_words(comment.created_at) }
    node(:user_name) {|comment| comment.user.name }
    node(:user_gravatar) {|comment| comment.user.gravatar }
    node(:text) { |comment| markdown(comment.text) }
  end
end
