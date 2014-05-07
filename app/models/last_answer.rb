class LastAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question
  belongs_to :user
  belongs_to :team

  has_one :answer, class_name: "Answers::Soluction", inverse_of: :last_answer, dependent: :nullify

  attr_accessible :question_id, :correct, :attempt_number, :response, :team_id

  scope :by_user, lambda { |user, team|
    where(user_id: user.id, team_id: team.try(:id))
  }

  scope :by_user_id, lambda { |user_id, team_id|
    where(user_id: user_id, team_id: team_id)
  }

  def update_answer(new_answer)
    if answer
      answer.set(:last_answer_id, nil)
    end
    new_answer.set(:last_answer_id, self.id)
    self.answer= new_answer
  end

  def self.answer_where(conditions)
    la = where(conditions).try(:first)

    return la.answer if la
  end
end
