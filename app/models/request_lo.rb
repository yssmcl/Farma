#encoding: utf-8
require 'concerns/deep_clone.rb'
class RequestLo
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user_from, class_name: 'User', inverse_of: :requests_for_los_from_me
  belongs_to :user_to, class_name: 'User', inverse_of: :requests_for_los_to_me
  belongs_to :lo, class_name: 'Lo', inverse_of: :requests

  STATUS_OPTIONS = ['waiting', 'authorized', 'not_authorized']

  field :status, :type => String, default: STATUS_OPTIONS[0]

  index status: 1

  validates_presence_of :user_from_id, :status

  before_save :set_user_to

  scope :waiting, where(status: 'waiting').includes(:user_to, :user_from, :lo)
  scope :canceled, where(status: 'canceled').includes(:user_to, :user_from, :lo)
  scope :authorized, where(status: 'authorized').includes(:user_to, :user_from, :lo)

  # Set the user that is requesting
  def to(user)
    self.user_from= user
    save
    self
  end

  # Register a resquest
  def self.request(lo_id)
    Lo.find(lo_id).requests.build
  end

  def authorize
    DeepCloneLo.clone(lo, user_from)
    update_attribute(:status, STATUS_OPTIONS[1])
  end

  def not_authorize
    update_attribute(:status, STATUS_OPTIONS[2])
  end
private
  # Set the receive of requests from his lo
  def set_user_to
    self.user_to_id = self.lo.user.id
  end
end
