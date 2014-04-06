class Answers::Exercise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :title, type: String
  field :content, type: String

  embeds_many :questions, class_name: "Answers::Question", inverse_of: :exercise
  embedded_in :soluction, class_name: "Answers::Soluction",  inverse_of: :exercise

  index({ from_id: 1})

  validates_presence_of :title, :content
end
