#encoding: utf-8
class CommentMailer < ActionMailer::Base

  def send_message(answer, user, url)
    @comment = answer.comments.last
    @answer = answer
    @url = url
    mail from: APP_CONFIG[:email][:account],
         to: user.email,
         subject: "[FARMA] Você recebeu um novo comentário"
  end

end
