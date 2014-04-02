desc "Send mailing"

task :send_request_receive => :environment do
  request = RequestLo.find(ENV["REQUEST_ID"])
  RequestLoMailer.send_receive_request(request).deliver
end

task :send_request_authorized => :environment do
  request = RequestLo.find(ENV["REQUEST_ID"])
  RequestLoMailer.send_authorized_request(request).deliver
end

task :send_request_not_authorized => :environment do
  request = RequestLo.find(ENV["REQUEST_ID"])
  RequestLoMailer.send_not_authorized_request(request).deliver
end

task :send_message_mailing => :environment do
  answer = Answers::Soluction.find(ENV["ANSWER_ID"])

  default_url = "http://#{APP_CONFIG[:host][Rails.env.to_sym]}/answers"

  ids = []
  user_id = answer.user.id
  owner_id = answer.team.owner_id

  # If the answer is correct then just the team onwer and
  # the user who made the erros receive a email
  # Other size:
  # The other and all the users of the same team receive
  # a email
  unless (answer.correct?)
    ids = answer.team.users.pluck(:id)
  end

  # Send a email to the team owner
  url = "#{default_url}/teams-created/#{answer.id}"
  user = User.find(owner_id)
  CommentMailer.send_message(answer, user, url, "team_owner").deliver

  # Send a email to the answer owner
  url = "#{default_url}/my/#{answer.id}"
  user = User.find(user_id)
  CommentMailer.send_message(answer, user, url, "answer_owner").deliver

  # Send a email to the learner of same team
  url = "#{default_url}/teams-enrolled/#{answer.id}"
  ids.each do |id|
    user = User.find(id)
    CommentMailer.send_message(answer, user, url, "collegue_learner").deliver
  end
end
