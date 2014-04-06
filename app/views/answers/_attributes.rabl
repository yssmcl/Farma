#encoding: utf-8
object @answer

attributes :id, :response, :attempt_number, :correct

node(:created_at) {|an| l an.created_at}
node(:team) {|an| an.team.name}

## name can be show just for the user and the owner of team
node(:user_name) { |an| an.user.name }
node(:user_email) { |an| an.user.email}

node(:lo) {|an| an.lo.name}
node(:exercise) {|an| an.exercise.title}
node(:question) {|an| an.question.title}

node(:comments_size) {|an| an.comments.size}
