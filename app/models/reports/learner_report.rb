class Reports::LearnerReport
  include Mongoid::Document
  include Mongoid::Timestamps

  field :team_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :percentage_completed, type: Float, default: 0.0
  field :exercises_done_amount, type: Float, default: 0.0
  field :exercises_done_correctly_amount, type: Float, default: 0.0


  belongs_to :user, inverse_of: :reports

  index({ team_id: 1})
  index({ lo_id: 1})

  validates :user_id, uniqueness: { scope: [:team_id, :lo_id ] }
  validates :user_id, :lo_id, :team_id, presence: true

  attr_accessible :user_id, :team_id, :lo_id


  def calculate
    calculate_amount
    return 0.0 if (@questions_amount == 0)
    result = ( @ledc_amount / @questions_amount) * 100.0
    result = (result * 100).floor / 100.0
    update_attribute(:percentage_completed, result)
    update_attribute(:exercises_done_amount, @eda) # substituir por +1 não é mais eficiente?
    update_attribute(:exercises_done_correctly_amount, @caqa)
  end

private
  # TODO: For better performance use counter cache
  def calculate_amount
    #debugger
    @questions_amount = 0.0
    @caqa = 0.0 # correct_answers_questions_amount
    @eda = 0.0 # exercises_done_amount
    @ledc_amount = 0.0 #last_exercise_done_correctly

    #last_question_id = ""
    Lo.find(self.lo_id).exercises_avaiable.each do |exercise|
      #@questions_amount += exercise.questions_available.count
      exercise.questions_available.each do |question|
        ans = user.answers.corrects.where(from_question_id: question.id).limit(1).first
        #@caqa += 1 if ans
        if ans
          @caqa += 1
          #@last_question_id = ans.from_question_id
        end
      end
    end

    @questions_amount = Lo.find(self.lo_id).exercises_avaiable.count
    exercises_ordering = Sequence::AutoSequence.where(user_id: self.user_id, lo_id: self.lo_id).first.exercises_ordering
    user_sequence = exercises_ordering.user_sequence
    i = 0.0
    #user_sequence_caqa = 0.0

    # TODO: se o aprendiz errar a primeira questão, `user.answers.corrects.last` é nil
    if user.answers.corrects.last
      ledc_id = Question.find(user.answers.corrects.last.from_question_id).exercise_id
      while (i < @questions_amount ) do
        if user_sequence[i][0].to_str == ledc_id.to_str
        #if user_sequence[i][0].to_str == Question.find(@last_question_id).exercise_id.to_str
          @ledc_amount = i + 1
        elsif user_sequence[i][3]
          @ledc_amount = i + 1
        end
        if (user_sequence[i][2])
          @eda += 1
        end
        i += 1
      end
      @eda += 1
    end

    #while (i < @questions_amount) do
    #  if (user_sequence[i][2])
        #@eda +=1
    #    if (user_sequence[i][3])
    #      @ledc_amount = i  + 1.0
    #      user_sequence_caqa += 1
    #    end
    #  end
    #  i = i + 1
    #end
    #@eda +=1


    #if (@caqa > user_sequence_caqa) #nao esta contabilizada ainda a resposta atual
    #  @ledc_amount += exercises_ordering.step_size
    #end


  end
end

