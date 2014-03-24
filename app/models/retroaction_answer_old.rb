require 'math_evaluate'

class RetroactionAnswerOld
  include Mongoid::Document
  include Mongoid::Timestamps
  include MathEvaluate

  field :response
  field :correct, type: Boolean
  field :tip, type: String, default: ''
  field :tips, type: Array, default: Array.new()
  field :try_number, type: Integer, default: 0
  field :answer_id, type: Moped::BSON::ObjectId
  field :question_id, type: Moped::BSON::ObjectId

  attr_accessible :id, :response, :user_id, :answer_id, :question_id

  belongs_to :user

  before_save :verify_response

  def answer
    @answer ||= Answer.find(self.answer_id)
  end

  def question_json
    @question_json ||= answer.super_exercise['questions'].select {|question| question['id'] == self.question_id}[0]
  end

  def question
    @question ||= Question.new(question_json)
  end

private
  def set_try_number
    if question
      self.try_number = @question_json['tries']
    end
  end

  def verify_response
    options = {variables: question_json['exp_variables']}
    correct_answer = question_json['correct_answer']

    if question_json['many_answers']
      self.correct= MathEvaluate::Expression.eql_with_many_answers?(correct_answer, self.response, options)
    elsif question_json['eql_sinal']
      self.correct= MathEvaluate::Expression.eql_with_eql_sinal?(correct_answer, self.response, options)
    else
      self.correct= MathEvaluate::Expression.eql?(correct_answer, self.response, options)
    end

    if !self.correct
      set_tip
    else
      self.tip= ''
    end
  end

  def set_tip
    self.try_number = question_json['tries'] if self.try_number == 0
    self.try_number += 1
    tip = question_json['tips'].select {|tip| tip['number_of_tries'] <= self.try_number }
    self.tips = tip.map {|t| [t['number_of_tries'], t['content']]}
    if tip.first
      self.tip = tip.first['content']
    end
  end
end
