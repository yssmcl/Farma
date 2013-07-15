#encoding: utf-8
object false

node(:total) {|m| @answers.total_count }
node(:total_pages) {|m| @answers.num_pages }

child @answers do
  attributes :id, :tip, :response, :try_number, :correct, :many_answers

  node(:created_at) {|an| l an.created_at}
  node(:team) {|an| an.team.name}
  node(:team_id) {|an| an.team.id}
  node(:user_id) {|an| an.user.id}

  # the collegues name is not show
  node(:user_name) { "Não identificado" }
  node(:user_email) { "Não identificado" }

  node(:lo) {|an| an.lo.name}
  node(:exercise) {|an| an.exercise.title}
  node(:question) {|an| an.question.title}
  node(:many_answers) {|an| an.question.many_answers}

  node(:comments_size) {|an| an.comments.size}
end
