class Reports::RetroactionView
  include Mongoid::Document
  include Mongoid::Timestamps

  field :answer_id, type: Moped::BSON::ObjectId
  field :user_id, type: Moped::BSON::ObjectId
end
