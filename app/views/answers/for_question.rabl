collection @answers

attributes :id, :response, :attempt_number, :correct

node(:created_at) {|an| l an.created_at}
node(:comments_size) {|an| an.comments.size}
