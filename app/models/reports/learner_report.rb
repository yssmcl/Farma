class Reports::LearnerReport
  include Mongoid::Document
  include Mongoid::Timestamps

  field :team_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :percentage_completed, type: Float, default: 0.0

  belongs_to :user, inverse_of: :reports

  index({ team_id: 1})
  index({ lo_id: 1})

  validates :user_id, uniqueness: { scope: [:team_id, :lo_id ] }
  validates :user_id, :lo_id, :team_id, presence: true

  attr_accessible :user_id, :team_id, :lo_id

  def calculate
    calculate_amount
    return 0.0 if (@questions_amount == 0)
    result = ( @caqa / @questions_amount) * 100.0
    result = (result * 100).floor / 100.0
    update_attribute(:percentage_completed, result)
  end

private
  # TODO: For better performance use counter cache
  def calculate_amount
    @questions_amount = 0.0
    @caqa = 0.0 # correct_answers_questions_amount
    Lo.find(self.lo_id).exercises_avaiable.each do |exercise|
      @questions_amount += exercise.questions_available.count
      exercise.questions_available.each do |question|
        ans = user.answers.corrects.where(from_question_id: question.id).limit(1).first
        @caqa += 1 if ans
      end
    end
  end
end

