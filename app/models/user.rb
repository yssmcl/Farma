class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ''
  field :encrypted_password, :type => String, :default => ''

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  index({ email: 1 }, { unique: true, background: true })

  field :name, :type => String
  field :gravatar
  field :admin, :type => Boolean, default: false
  field :guest, :type => Boolean, default: false

  attr_accessible :id, :name, :email, :password, :password_confirmation, :remember_me, :guest

  validates_presence_of :name

  before_save :do_gravatar_hash

  has_many :los, dependent: :delete

  has_many :answers, class_name: "Answers::Soluction", dependent: :destroy
  has_many :reports, class_name: "Reports::LearnerReport", dependent: :destroy

  has_many :retroaction_answers, dependent: :destroy
  has_many :last_answers, dependent: :destroy

  has_many :requests_for_los_from_me,
            class_name: 'RequestLo', inverse_of: :user_from, dependent: :destroy
  has_many :requests_for_los_to_me,
            class_name: 'RequestLo', inverse_of: :user_to, dependent: :destroy

  has_and_belongs_to_many :teams

  def do_gravatar_hash
    self.gravatar= Digest::MD5.hexdigest(self.email)
  end

  def owner_teams
    @owner_teams = Team.where(owner_id: self.id)
  end

  # Exercises completeness of lo belongs to a team
  # in percentage
  def completeness_of(team, lo)
    r = self.reports.where(team_id: team.id, lo_id: lo.id).first
    r.nil? ? 0.0 : r.percentage_completed
  end

  def self.guest
    @user ||= User.where(email: 'guest@farma.mat.br').first
    return @user
  end
end
