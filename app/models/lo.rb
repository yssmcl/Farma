class Lo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :available, type: Boolean, default: false

  attr_accessible :id, :name, :description, :available

  validates_presence_of :name, :description
  validates :name, uniqueness: true
  validates :available, :inclusion => {:in => [true, false]}
  validates_length_of :name, :maximum => 100

  belongs_to :user

  has_many :requests, class_name: 'RequestLo', dependent: :delete
  has_many :introductions, dependent: :delete
  has_many :exercises, dependent: :delete

  # Knows who copies who
  belongs_to :copy_from, class_name: 'Lo', inverse_of: :copies
  has_many :copies, class_name: 'Lo', inverse_of: :copy_from

  has_and_belongs_to_many :teams

  def pages
    self.introductions_avaiable + self.exercises_avaiable
  end

  def pages_count
    self.pages.size
  end

  def pages_with_name
    i, e, page_count = 0, 0, 0

    self.pages.map do |page|
      if page.instance_of? Introduction
        i += 1
        page_count = i
      else
        e += 1
        page_count = e
      end
      { page_name: "#{page.class.model_name.human} #{page_count}: #{page.title}",
        type: page.class.to_s.downcase,
        page_collection: page_count-1
      }
    end
  end

  # Get the status of shared lo for a
  # user request
  def shared_status_for(user)
    rts = requests.where(user_from_id: user.id).desc
    rts.first.try(:status)
  end

  # Return scope not the records
  def self.search(search)
    if search
      rs = where(available: true).any_of({:name => /.*#{search}.*/i}, {:description => /.*#{search}.*/i})
    else
      rs = where(available: true)
    end
    rs.includes(:user).desc(:created_at)
  end

  def exercises_avaiable
    self.exercises.where(available: true)
  end

  def introductions_avaiable
    self.introductions.where(available: true)
  end
end
