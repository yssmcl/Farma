require 'math_evaluate'

class RetroactionAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  include MathEvaluate

  field :question_id, type: Moped::BSON::ObjectId
  field :response
  field :correct, type: Boolean

  index({ question_id: 1})

  belongs_to :user
  belongs_to :answer, class_name: "Answers::Soluction"

  attr_accessible :id, :response, :user_id, :answer_id, :question_id
  before_create  :verify_response

  def question
    @question ||= Answers::Soluction.find(self.answer_id).
                                       exercise.questions.find(self.question_id)
  end

private
  def verify_response
    options = { variables:  question.exp_variables,
                cmas_order: question.cmas_order,
                precision:  question.precision}

    self.correct= right_response?(question.correct_answer, self.response, options)
    true # continue before_create callbacks
  end

  def right_response?(reference, response, options)
    exp = MathEvaluate::Expression

    if question.many_answers?
      exp.eql_with_many_answers?(reference, response, options)
    elsif question.eql_sinal?
      exp.eql_with_eql_sinal?(reference, response, options)
    else
      exp.eql?(reference, response, options)
    end
  end
end
