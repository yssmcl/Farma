class Exercise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer
  field :subtopic, type: String, default: "No subtopic given so far!"

  default_scope asc(:position)
  #default_scope order_by([:position, :desc])

  before_create :set_position, :setSubtopicPattern

  before_save :setSubtopicPattern

  attr_accessible :id, :title, :content, :available, :questions_attributes, :subtopic, :introduction_ids

  validates_presence_of :title, :content, :subtopic
  validates :available, :inclusion => {:in => [true, false]}
  validates_length_of :title, :maximum => 55

  belongs_to :lo

  has_many :questions, dependent: :destroy
  #has_and_belongs_to_many :subtopics
  #Não funfou

  # Pré-requisitos do exercício
  has_and_belongs_to_many :introductions

  # Removed on 07/05/2014
  # Because its no long allowed a user clear your answers
  #def delete_last_answers_of(user_id)
  #  self.questions.each  do |question|
  #    question.last_answers.where(user_id: user_id).try(:destroy_all)
  #    question.tips_counts.where(user_id: user_id).try(:destroy_all)
  #  end
  #end

  def questions_available
    self.questions.where(available: true)
  end

private
  def set_position
    self.position = Time.now.to_i
  end

  def setSubtopicPattern
    self.subtopic.downcase!
    self.subtopic = ActiveSupport::Inflector.transliterate(self.subtopic)
  end
end
