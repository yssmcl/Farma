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

  index({ team_id: 1, to_test: 1}, { unique: true })
  index({ team_id: 1, to_test: 1, correct: 1})

  attr_accessible :response, :from_question_id, :to_test, :team_id

  belongs_to :user
  belongs_to :team, inverse_of: :answers
  has_one :last_answer, dependent: :destroy

  has_one :lo, class_name: "Answers::Lo", inverse_of: :soluction, dependent: :destroy
  has_one :question, class_name: "Answers::Question", inverse_of: :soluction, dependent: :destroy
  has_one :exercise, class_name: "Answers::Exercise", inverse_of: :soluction, dependent: :destroy

  has_many :retroaction_answers, inverse_of: :answer, dependent: :destroy

  embeds_many :comments, :as => :commentable

  before_create :copy_datas,  # order is relevant
                :verify_response,
                :set_tip

  after_create :register_last_answer,
               :copy_last_answers

  # Excludes temp answers
  #   temp answers are used by professer to test your answers
  scope :every, excludes(team_id: nil, to_test: true)
  scope :wrong, every.where(correct: false)
  scope :corrects, every.where(correct: true)


  def original_question
    @original_question ||= ::Question.find(self.from_question_id)
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
    Answers::Soluction.includes(:user).every.
                       where(user_id: user.id).where(conditions).
                       desc(:created_at)
  end

  # return only answers of a teams grup
  def self.search_in_teams_enrolled(user, conditions = {})
    conditions.delete('correct') if conditions
    Answers::Soluction.includes(:user).wrong.where(conditions).
      in(team_id: Team.ids_enrolled_by_user(user)).
      excludes(user_id: user.id).
      desc(:created_at)
  end

  # return only answers of a teams created
  def self.search_in_teams_created(user, conditions = {})
    if user.admin?
      ans = Answers::Soluction.includes(:user).every.where(conditions)
    else
      ans = Answers::Soluction.includes(:user).every.where(conditions).
        in(team_id: Team.ids_created_by_user(user))
    end
    ans.desc(:created_at)
  end

  # User can see only your name and name of your own team learners
  # leaners can't not see the other learners name
  def can_see_user?(user)
    (user.id === self.user.id) || (user.id === self.team.owner_id) || user.admin?
  end
private

  # For each soluction its necessary
  # to copy its context
  def copy_datas
    copy_lo_datas
    copy_exercise_datas
    set_question_answered
  end

  def copy_lo_datas
    original_lo = original_question.exercise.lo
    self.lo= Answers::Lo.create_from(original_lo, self)
  end

  def set_question_answered
    #self.question= Answers::Question.copy_for_soluction(original_question, self)
    cquestion = exercise.questions.where(from_id: self.from_question_id).first
    cquestion.update_attributes(soluction_id: self.id)
    self.question= cquestion
  end

  def copy_exercise_datas
    self.exercise= Answers::Exercise.create_from(original_question.exercise, self)
  end

  def verify_response
    options = { variables: original_question.exp_variables }

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
    tips_count = original_question.tips_counts.find_or_create_by(:user_id => self.user_id)
    self.attempt_number= tips_count.tries
    return if self.correct?

    tips_count.inc(:tries, 1)
    self.attempt_number= tips_count.tries
  end

  def register_last_answer
    unless self.to_test
      @last_answer = self.user.last_answers.find_or_create_by(:question_id => self.from_question_id)
      @last_answer.set(:answer_id, self.id)
    end
  end

  def copy_last_answers
    exercise.questions.each do |q|
      la = ::Question.find(q.from_id).last_answer(user)
      if la
        Answers::LastAnswer.create question_id: q.id,
                                   answer_id: la.answer.id
      end
    end
  end
end
