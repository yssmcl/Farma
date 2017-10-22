class Introduction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :available, type: Boolean, default: false
  field :position, type: Integer

  default_scope asc(:position)

  before_create :set_position

  attr_accessible :id, :title, :content, :available

  validates_presence_of :title, :content
  validates :available, :inclusion => {:in => [true, false]}

  belongs_to :lo
  belongs_to :exercise

private
  def set_position
    self.position = Time.now.to_i
  end
end
