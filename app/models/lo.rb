class Lo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :available, type: Boolean, default: false

  # cache for amount of questions
  field :questions_available_count, type: Integer, default: 0

  attr_accessible :id, :name, :description, :available

  validates_presence_of :name, :description
  validates :name, uniqueness: true
  validates :available, :inclusion => {:in => [true, false]}
  validates_length_of :name, :maximum => 100

  belongs_to :user

  has_many :requests, class_name: 'RequestLo', dependent: :destroy
  has_many :introductions, dependent: :destroy
  has_many :exercises, dependent: :destroy

  # Knows who copies who
  belongs_to :copy_from, class_name: 'Lo', inverse_of: :copies
  has_many :copies, class_name: 'Lo', inverse_of: :copy_from

  has_and_belongs_to_many :teams

  def contents
    @contents ||= (introductions + exercises).sort {|a,b| a.position <=> b.position}
    define_number_method_for_contents
  end

  def pages
    @pages ||= (self.introductions_avaiable + self.exercises_avaiable).sort {|a,b| a.position <=> b.position}
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

private
  # This is necessary to show exercise and introduction order independently
  def define_number_method_for_contents
    i, e = 0, 0
    @contents.each do |el|
      def el.number
        @number
      end
      def el.number=(number)
        @number = number
      end

      if el.instance_of? Introduction
        i += 1
        el.number= i
      else
        e += 1
        el.number= e
      end
    end
  end
end
