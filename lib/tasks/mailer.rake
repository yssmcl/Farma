desc "Send mailing"

task :send_message_mailing => :environment do
  answer = Answer.find(ENV["ANSWER_ID"])

  users_ids = answer.comments.distinct(:user_id)
  users_ids = users_ids | [answer.user.id]

  default_url = "http://#{APP_CONFIG[:host][Rails.env.to_sym]}/answers/my/#{answer.id}"

  users_ids.each do |id|
    user = User.find(id)

    if answer.user.id === id
      params = "my"
    elsif answer.can_see_user?(user)
      params = "teams-created"
    else
      params = "teams-enrolled"
    end

    url = default_url.gsub('my', params)
    CommentMailer.send_message(answer, user, url).deliver
  end
end
