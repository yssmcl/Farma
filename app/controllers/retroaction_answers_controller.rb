class RetroactionAnswersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    # store all retroaction for reports
    @retroaction = current_user.retroaction_answers.create(params[:retroaction_answer])

    # temporary attempt for retroaction answers
    @question_id = @retroaction.question.id
    store_atempt_number

    # get tips
    @tips = @retroaction.question.tips_for(session[:retroaction][@question_id])
  end

private
  def store_atempt_number
    session[:retroaction] ||= {}
    unless session[:retroaction][@question_id]
      if (la = @retroaction.question.last_answer)
        session[:retroaction][@question_id] = la.attempt_number + 1
      else
        session[:retroaction][@question_id] = 1
      end
    else
      session[:retroaction][@question_id] = session[:retroaction][@question_id] + 1
    end
  end

end
