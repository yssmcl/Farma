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


  # ================================================
  control = [ "ale_diniz98@hotmail.com",
                "gustavogta20@hotmail.com",
                "lucasnunesme@gmail.com",
                "luisfelippeflores@gmail.com",
                "annacarazzai@hotmail.com",
                "re_nan_diego@hotmail.com",
                "hector.iniesta@hotmail.com",
                "andre.fernandes1997@hotmail.com",
                "lucas.andre12451@gmail.com",
                "matheus_martelotti@hotmail.com",
                "gregor.lohan@hotmail.com",
                "leonardo_cardosodossantos@hotmail.com",
                "nathaliapb2008@hotmail.com",
                "suellen_skc@hotmail.com",
                "jonathanlus@hotmail.com",
                "benjamim_fernando@hotmail.com",
                "marialuiza_g@hotmail.com",
                "saracristina.martins@hotmail.com",
                "kekinha-mara@hotmail.com",
                "lucastamarossi_@hotmail.com",
                "giovannibs2013@gmail.com",
                "mfkipper@hotmail.com",
                "yuri.soares98@hotmail.com",
                "camila_solivam@hotmail.com",
                "theus.topolski@gmail.com",
                "leonardo-santoss@outlook.com",
                "durval_gab@hotmail.com",
                "junior_phoda@live.com",
                "dvs.olie@hotmail.com;dvs.olie@hormail.com",
                "isa.bela_26@hotmail.com",
                "leonardockeller@gmail.com",
                "leonardo.simao@hotmail.com.br",
                "leonardovitornunes@hotmail.com",
                "viniciuspadilha_silva@hotmail.com"
    ]
  # ================================================

  # Send a email to the learner of same team
  url = "#{default_url}/answers/teams-enrolled/#{answer.id}"
  ids.delete(owner_id)
  ids.delete(user_id)
  ids.each do |id|
    user = User.find(id)
    next if control.include?(user.email)
    CommentMailer.send_message(answer, user, url, "collegue_learner").deliver
  end
end
