class Answers::LastAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question, class_name: "Answers::Question",  inverse_of: :last_answer
  belongs_to :answer, class_name: "Answers::Soluction",  inverse_of: :last_answer
end

