class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :correct_answer, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer
  #field :compartion_type, type: String, default: 'expression'
  field :exp_variables, type: Array, default: []
  field :many_answers, type: Boolean, default: false
  field :eql_sinal, type: Boolean, default: false

  default_scope asc(:position)

  before_create :set_position
  before_save :set_exp_variables

  attr_accessible :id, :title, :content, :correct_answer, :available, :comparation_type, :many_answers

  validates_presence_of :title, :content, :correct_answer
  validates :available, :inclusion => {:in => [true, false]}
  validates_length_of :title, :maximum => 55
  #validates :compartion_type, :inclusion => {:in => ['result', 'expression']}

  belongs_to :exercise
  has_many :tips, dependent: :destroy
  has_many :tips_counts, dependent: :destroy
  has_many :last_answers, dependent: :destroy #one last answer for each user

  def correct_answer=(correct_answer)
    super(correct_answer.downcase)
  end

  # return all tips with
  # attempt number less then 
  # number_of_tries tip
  def tips_for(attempt)
    self.tips.where(:number_of_tries.lte => attempt).desc(:number_of_tries)
  end

  def has_last_answer?(user)
    return false unless user
    last_answers.each do |l|
      puts "#{l.user.id} : #{user.id}"
    end
    last_answers.by_user(user).size > 0
  end

  def last_answer(user)
    last_answers.by_user(user).try(:first)
  end

private
  def set_position
    self.position = Time.now.to_i
  end

  def set_exp_variables
    self.eql_sinal = self.correct_answer.to_s.include?('=')
    self.many_answers = self.correct_answer.to_s.include?(';')
    self.exp_variables = self.correct_answer.scan(/[a-z][a-z0-9_]*/).uniq
  end
end
