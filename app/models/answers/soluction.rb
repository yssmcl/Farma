require 'math_evaluate'

class Answers::Soluction
  include Mongoid::Document
  include Mongoid::Timestamps
  include MathEvaluate

  field :from_question_id, type: Moped::BSON::ObjectId
  field :response
  field :correct, type: Boolean
  field :to_test, type: Boolean, default: false
  field :attempt_number, type: Integer

  index({ to_test: 1}, {background: true})
  index({ to_test: 1, correct: 1}, {background: true})
  index({ team_id: 1, to_test: 1}, { unique: true,background: true })
  index({ team_id: 1, to_test: 1, correct: 1}, {background: true})
  index({ team_id: 1, to_test: 1, from_question_id: 1}, {background: true})

  attr_accessible :response, :from_question_id, :to_test, :team_id,
                  :created_from, :answers_last_answer, :user_id

  belongs_to :user
  belongs_to :team, inverse_of: :answers

  belongs_to :last_answer, class_name: "LastAnswer", inverse_of: :answer, dependent: :destroy

  embeds_one :lo, class_name: "Answers::Lo", inverse_of: :soluction
  embeds_one :exercise, class_name: "Answers::Exercise", inverse_of: :soluction

  has_many :retroaction_answers, inverse_of: :answer, dependent: :destroy

  embeds_many :comments, :as => :commentable

  before_create :verify_response, :set_tip

  after_create :register_last_answer, :copy_datas, :register_progress

  # Excludes temp answers
  #   temp answers are used by professer to test your answers
  scope :every, excludes(team_id: nil, to_test: true)
  scope :wrong, every.where(correct: false)
  scope :corrects, every.where(correct: true)

  def original_question
    @original_question ||= ::Question.find(self.from_question_id)
  end

  def question
    @question ||= exercise.questions.where(soluction_id: self.id).first
  end

  def tips
    @tips ||= question.tips_for(self.attempt_number)
  end

  # admin can search all in all the answers
  # regular user
  #   can see all your answer
  #   can see all students' answers of your own team
  #   can see only wrong studens' answers of students that participed of same team

  # return only answers of specific user
  def self.search_of_user(user, conditions = {})
    Answers::Soluction.every.
                       where(user_id: user.id).where(conditions).
                       desc(:created_at)
  end

  # return only answers of a teams grup
  def self.search_in_teams_enrolled(user, conditions = {})
    conditions.delete('correct') if conditions

    Answers::Soluction.wrong.where(conditions).
      in(team_id: Team.ids_enrolled_by_user(user)).
      excludes(user_id: user.id).
      desc(:created_at)
  end

  # return only answers of a teams created
  def self.search_in_teams_created(user, conditions = {})
    ans = Answers::Soluction.every.where(conditions)
    unless user.admin?
      ans = ans.in(team_id: Team.ids_created_by_user(user))
    end
    ans.desc(:created_at)
  end

  # User can see only your name and name of your own team learners
  # leaners can't not see the other learners name
  def can_see_user?(user)
    (user.id === self.user.id) || (user.id === self.team.owner_id) || user.admin?
  end

private

  # ============================================================ #
  # For each soluction its necessary
  # to copy its context
  def copy_datas
    copy_lo
    copy_exercise
  end

  def copy_lo
    original_lo = original_question.exercise.lo
    self.create_lo from_id: original_lo.id,
                   name: original_lo.name,
                   description: original_lo.description
  end

  def copy_exercise
    copied_exercise = self.create_exercise from_id: original_question.exercise.id,
                         title:   original_question.exercise.title,
                         content: original_question.exercise.content

    copy_exercise_questions(copied_exercise)
  end

  def copy_exercise_questions(copied_exercise)
    original_question.exercise.questions.each do |question|

    s_id = (question.id == self.from_question_id) ? self.id : nil

    copied_question = copied_exercise.questions.create from_id: question.id,
                                       title: question.title,
                                       content: question.content,
                                       correct_answer: question.correct_answer,
                                       position: question.position,
                                       exp_variables: question.exp_variables,
                                       many_answers: question.many_answers,
                                       eql_sinal: question.eql_sinal,
                                       cmas_order: question.cmas_order,
                                       precision: question.precision,
                                       soluction_id: s_id


      copy_question_tips(question, copied_question)
      copy_question_last_answer(question, copied_question)
    end
  end

  def copy_question_last_answer(question, copied_question)
    la = question.last_answer(user, team)
    if la && (ans = la.answer)
      copied_question.create_last_answer response: ans.response,
                                         attempt_number: ans.attempt_number,
                                         correct: ans.correct
    end
  end

  def copy_question_tips(question, copied_question)
    question.tips.each do |tip|
      copied_question.tips.create from_id: tip.id,
                                  content: tip.content,
                                  number_of_tries: tip.number_of_tries
    end
  end

  # ============================================================ #

  def verify_response
    options = { variables: original_question.exp_variables,
                cmas_order: original_question.cmas_order,
                precision: original_question.precision}

    self.correct= right_response?(original_question.correct_answer, self.response, options)
    true # continue before_create callbacks
  end

  def right_response?(reference, response, options)
    exp = MathEvaluate::Expression

    if original_question.many_answers?
      exp.eql_with_many_answers?(reference, response, options)
    elsif original_question.eql_sinal?
      exp.eql_with_eql_sinal?(reference, response, options)
    else
      exp.eql?(reference, response, options)
    end
  end

  def set_tip
    tips_count = original_question.tips_counts.
                                   find_or_create_by(user_id: self.user_id,
                                                     team_id: self.team_id)
    tips_count.inc(:tries, 1)
    self.attempt_number= tips_count.tries
  end

  def register_last_answer
    unless self.to_test
      @last_answer = self.user.last_answers.
                          find_or_create_by(question_id: self.from_question_id,
                                            team_id: self.team_id)
      @last_answer.update_answer(self)
    end
  end

  # ============================================================ #
  def register_progress
    if not(self.to_test) && not(self.team.nil?)
      rts = Reports::LearnerReport.find_or_create_by user_id: self.user_id,
                                                     team_id: self.team_id,
                                                     lo_id: original_question.exercise.lo.id
      rts.calculate
    end
  end

end
