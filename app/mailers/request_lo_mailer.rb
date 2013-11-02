# encoding: utf-8
class RequestLoMailer < ActionMailer::Base

  def send_receive_request(request)
    @request = request
    @url = "http://#{APP_CONFIG[:host][Rails.env.to_sym]}/dashboard"
    mail from: @request.user_from.email,
         to: @request.user_to.email,
         cc: APP_CONFIG[:email][:account],
         reply_to: @request.user_from.email,
         subject: "[FARMA] Solicitação de compartilhamento"
  end

  def send_authorized_request(request)
    @request = request
    @url = "http://#{APP_CONFIG[:host][Rails.env.to_sym]}/my-los"
    mail from: @request.user_to.email,
         to: @request.user_from.email,
         cc: APP_CONFIG[:email][:account],
         reply_to: @request.user_to.email,
         subject: "[FARMA] Solicitação de compartilhamento autorizada"
  end

  def send_not_authorized_request(request)
    @request = request
    mail from: @request.user_to.email,
         to: @request.user_from.email,
         cc: APP_CONFIG[:email][:account],
         reply_to: @request.user_to.email,
         subject: "[FARMA] Solicitação de compartilhamento não autorizada"
  end
end
