class Answers::Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :title, type: String
  field :content, type: String
  field :correct_answer, type: String
  field :position, type: Integer
  field :exp_variables, type: Array, default: []
  field :many_answers, type: Boolean, default: false
  field :eql_sinal, type: Boolean, default: false

  belongs_to :soluction, class_name: "Answers::Soluction",  inverse_of: :question
  belongs_to :exercise, class_name: "Answers::Exercise",  inverse_of: :question

  has_many :tips, class_name: "Answers::Tip",  inverse_of: :question, dependent: :destroy
  has_many :retroaction_answers, inverse_of: :question, dependent: :destroy

  has_one :last_answer, class_name: "Answers::LastAnswer",
           inverse_of: :question, dependent: :destroy

  default_scope includes(:last_answer)

  # return all tips with
  # attempt number less then 
  # number_of_tries tip
  def tips_for(attempt)
    self.tips.where(:number_of_tries.lte => attempt).desc(:number_of_tries)
  end

  # Create Answers::Question from
  # the original question
  def self.copy_for_exercise(oq, exercise) # oq is original_question
    question = self.build_from(oq)
    question.exercise_id= exercise.id
    question.save!
    self.copy_tips(question, oq)
  end

private
  def self.build_from(oq)
    Answers::Question.new from_id: oq.id,
                          title: oq.title,
                          content: oq.content,
                          correct_answer: oq.correct_answer,
                          position: oq.position,
                          exp_variables: oq.exp_variables,
                          many_answers: oq.many_answers,
                          eql_sinal: oq.eql_sinal
  end

  def self.copy_tips(question, oq)
    oq.tips.each do |tip|
      question.tips.create from_id: tip.id,
                           content: tip.content,
                           number_of_tries: tip.number_of_tries
    end
    question
  end
end

