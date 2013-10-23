class CommentNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :link, type: String
  field :comment_by_user_id, type: Moped::BSON::ObjectId

  belongs_to :user
  belongs_to :answer
end
