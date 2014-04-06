class Answers::Lo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :name, type: String
  field :description, type: String

  embedded_in :soluction, class_name: "Answers::Soluction",  inverse_of: :lo

  validates_presence_of :from_id, :name, :description

  index({ name: 1}, { unique: true })

end
