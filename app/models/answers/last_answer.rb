class Answers::LastAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :response
  field :correct, type: Boolean, default: false
  field :attempt_number, type: Integer

  belongs_to :question, class_name: "Answers::Question",  inverse_of: :last_answer

  attr_accessible :question_id, :response, :correct, :attempt_number

  def tips
    @tips ||= question.tips_for(self.attempt_number)
  end
end

