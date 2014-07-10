class Exercise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer

  default_scope asc(:position)
  #default_scope order_by([:position, :desc])

  before_create :set_position

  attr_accessible :id, :title, :content, :available, :questions_attributes

  validates_presence_of :title, :content
  validates :available, :inclusion => {:in => [true, false]}
  validates_length_of :title, :maximum => 55

  belongs_to :lo

  has_many :questions, dependent: :destroy

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
end
