class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :commentable, :polymorphic => true, :inverse_of => :comments

  field :text, type: String
  field :user_id, type: Moped::BSON::ObjectId

  after_create :notify_by_email

  attr_accessible :text, :user_id
  validates_presence_of :text, :user_id

  default_scope order_by([:created_at, :asc])

  def user
    @user ||= User.find(self.user_id)
  end

  def can_destroy?(current_user)
    self.created_at >= 15.minutes.ago && self.user_id == current_user.id
  end

  private
  def notify_by_email
    system "rake send_message_mailing ANSWER_ID=#{self.commentable.id} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end
end
