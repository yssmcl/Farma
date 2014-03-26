class LastAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question
  belongs_to :user

  has_one :answer, class_name: "Answers::Soluction", inverse_of: :last_answer, dependent: :nullify

  attr_accessible :question_id, :correct, :attempt_number, :response

  scope :by_user, lambda { |user|
    where(:user_id => user.id)
  }

  scope :by_user_id, lambda { |user_id|
    where(:user_id => user_id)
  }

  def update_answer(new_answer)
    if answer
      answer.set(:last_answer_id, nil)
    end
    new_answer.set(:last_answer_id, self.id)
    self.answer= new_answer
  end

  def self.answer_where(conditions)
    la = where(user_id: conditions[:user_id],
          question_id: conditions[:question_id]).try(:first)

    return la.answer if la
  end
end
