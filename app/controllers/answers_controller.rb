class AnswersController < ApplicationController
  before_filter :authenticate_user!, except: :create
  respond_to :json

  def index
    @answers = Answer.search(params[:search], current_user).page(params[:page]).per(20)
  end

  def create
    last = LastAnswer.where(user_id: current_or_guest_user.id, question_id: params[:answer][:question_id]).try(:first)

    if (last && last.answer && (last.answer.response == params[:answer][:response]))
      @answer = last.answer
    else
      @answer = current_or_guest_user.answers.create(params[:answer])
    end
  end

  def retroaction
    delete_retroaction_answers
    @answer = Answer.find(params[:id])
  end

private
  def delete_retroaction_answers
    retros = RetroactionAnswer.where(answer_id: params[:id], user_id: current_user.id)
    retros.delete_all
  end

end
