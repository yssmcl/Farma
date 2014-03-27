class AnswersController < ApplicationController
  before_filter :authenticate_user!, except: :create
  respond_to :json

  def index
  end

  # search only in current user answers
  def search_in_my
    @answers =  Answers::Soluction.search_of_user(current_user,
                                                  params[:search]).
                                                  page(params[:page]).per(20)
  end

  # search in teams enrolleds
  def search_in_teams_enrolled
    @answers = Answers::Soluction.search_in_teams_enrolled(current_user,
                                                           params[:search]).
                                                           page(params[:page]).per(20)
  end

  # search in teams created
  def search_in_teams_created
    @answers = Answers::Soluction.search_in_teams_created(current_user,
                                                         params[:search]).
                                                         page(params[:page]).per(20)
  end

  def create
    ap = params[:answer]
    ap[:from_question_id] = ap.delete(:question_id)

    @answer = LastAnswer.answer_where user_id: current_or_guest_user.id,
                                      question_id: ap[:from_question_id]

    unless (@answer && @answer.response == ap[:response])
      @answer = current_or_guest_user.answers.create(ap)
    end
  end

  def retroaction
    # store al retroaction for reports
    @answer = Answers::Soluction.includes([:user,
                                          :question,
                                          :team,
                                          :exercise,
                                          :question]).find(params[:id])

    session.delete(@answer.question.id)

    # Register access
    Reports::RetroactionView.create! answer_id: @answer.id,
                                     user_id: current_user.id
  end

end
