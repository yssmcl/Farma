collection @answers

attributes :id, :response, :attempt_number, :correct

node(:created_at) {|an| l an.created_at}
node(:comments_size) {|an| an.comments.size}

child(:comments) do
  attributes :id
  node(:created_at_in_words) { |comment|  time_ago_in_words(comment.created_at) }
  node(:user_name) {|comment| comment.user.name }
  node(:user_gravatar) {|comment| comment.user.gravatar }
  node(:text) { |comment| markdown(comment.text) }
end
