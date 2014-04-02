#encoding: utf-8
class CommentMailer < ActionMailer::Base

  def send_message(answer, user, url, user_type)

    if user_type.eql?("answer_owner")
      subject = "[FARMA] Novo comentário sobre sua resposta no OA #{answer.lo.name}"
    else
      subject = "[FARMA] Novo comentário no OA #{answer.lo.name} Turma: #{answer.team.name}"
    end

    @comment = answer.comments.last
    @answer = answer
    @url = url
    @user = user
    @user_type = user_type

    mail from: APP_CONFIG[:email][:account],
         to: user.email,
         subject: subject
  end

end
