class AnswersController < ApplicationController
  before_filter :authenticate_user!, except: :create
  before_filter :prepare_search_params, only: [:search_in_my, :search_in_teams_enrolled, :search_in_teams_created]
  respond_to :json

  def index
  end

  def for_question
    @answers = current_user.answers.every.
      where(from_question_id: params[:question_id]).
      desc(:created_at)
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

    @team = @answer.team
    @lo = Lo.find(@answer.lo.from_id)
  end

  def retroaction
    # store al retroaction for reports
    @answer = Answers::Soluction.includes([:user, :team]).find(params[:id])

    session.delete :retroaction
    # Register access
    Reports::RetroactionView.create! answer_id: @answer.id,
                                     user_id: current_user.id
  end

private
  def prepare_search_params
    if params[:search] && (lo_id = params[:search][:lo_id])
      params[:search]["lo.from_id"] = Moped::BSON::ObjectId.from_string(lo_id)
      params[:search].delete :lo_id
    end
    if params[:search] && (exercise_id = params[:search][:exercise_id])
      params[:search]["exercise.from_id"] = Moped::BSON::ObjectId.from_string(exercise_id)
      params[:search].delete :exercise_id
    end
  end

end
