class Reports::RetroactionView
  include Mongoid::Document
  include Mongoid::Timestamps

  field :answer_id, type: Moped::BSON::ObjectId
  field :user_id, type: Moped::BSON::ObjectId

  attr_accessible :answer_id, :user_id
end
