class Answers::Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :soluction_id, type: Moped::BSON::ObjectId
  field :title, type: String
  field :content, type: String
  field :correct_answer, type: String
  field :position, type: Integer
  field :exp_variables, type: Array, default: []
  field :many_answers, type: Boolean, default: false
  field :eql_sinal, type: Boolean, default: false
  field :position, type: Integer
  field :cmas_order, type: Boolean, default: true # cmas_order = consider_multiple_answers_order
  field :precision, type: Integer, default: 5

  embedded_in :exercise, class_name: "Answers::Exercise",  inverse_of: :question

  embeds_many :tips, class_name: "Answers::Tip",  inverse_of: :question
  embeds_one :last_answer, class_name: "Answers::LastAnswer",
              inverse_of: :question

  index({ from_id: 1})

  # return all tips with
  # attempt number less then 
  # number_of_tries tip
  def tips_for(attempt)
    self.tips.where(:number_of_tries.lte => attempt).desc(:number_of_tries)
  end

end

