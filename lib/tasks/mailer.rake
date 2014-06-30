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

  default_url = "http://#{APP_CONFIG[:host][Rails.env.to_sym]}"

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
  url = "#{default_url}/answers/teams-created/#{answer.id}"
  user = User.find(owner_id)
  CommentMailer.send_message(answer, user, url, "team_owner").deliver

  # Send a email to the answer owner
  # url = "#{default_url}/my/#{answer.id}"
  team_id = answer.team_id
  lo_id = answer.lo.from_id
  answer_id = answer.id
  exercise_id = answer.exercise.from_id
  page = 1 + Lo.find(lo_id).pages.index { |c| c.id == exercise_id}

  url = "#{default_url}/published/teams/#{team_id}/los/#{lo_id}/pages/#{page}/retroaction/#{answer_id}"

  user = User.find(user_id)
  CommentMailer.send_message(answer, user, url, "answer_owner").deliver

  # because other leaners should not see the answers of the other users
  # TODO: It not should see answers that he not answered correct
  url = nil # because other leaners should not see the answers of the other users
  ids.delete(owner_id)
  ids.delete(user_id)
  ids.each do |id|
    user = User.find(id)
    CommentMailer.send_message(answer, user, url, "collegue_learner").deliver
  end
end
