class Answers::Tip
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :content, type: String
  field :number_of_tries, type: Integer

  belongs_to :question, class_name: "Answers::Question",  inverse_of: :tips
end

