class LastAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question
  belongs_to :user
  #belongs_to :answer # remove after completed
  belongs_to :answer, class_name: "Answers::Soluction", inverse_of: :last_answer

  scope :by_user, lambda { |user|
    where(:user_id => user.id)
  }

  scope :by_user_id, lambda { |user_id|
    where(:user_id => user_id)
  }

  def self.answer_where(conditions)
    la = where(user_id: conditions[:user_id],
          question_id: conditions[:question_id]).try(:first)

    return la.answer if la
  end
end
