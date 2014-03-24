class RetroactionAnswersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    # store all retroaction for reports
    @retroaction = current_user.retroaction_answers.create(params[:retroaction_answer])

    # temporary attempt for retroaction answers
    @question_id = @retroaction.question.id
    session[@question_id] = @retroaction.answer.attempt_number unless session[@question_id]
    session[@question_id] = session[@question_id] + 1

    # get tips
    @tips = @retroaction.question.tips_for(session[@question_id])
  end
end
