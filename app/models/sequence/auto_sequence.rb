class Sequence::AutoSequence
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :team_id, type: Moped::BSON::ObjectId
  field :page_ids, type: Array, default: []
  field :next_page, type: Boolean, default: false

  embeds_one :exercises_ordering, class_name: "Sequence::ExercisesOrdering", inverse_of: :auto_sequence


  def lo
    @lo ||= Lo.find(self.lo_id)
  end

  def user
    @user ||= User.find(self.user_id)
  end

  before_create :insert_introduction_pages

  after_create :insert_first_exercise

  # Realizar calculos do auto sequenciamento aqui
  def calculates
    self.next_page = true
    id = exercises_ordering.nextExercise()
    if not(page_ids.include?(id.to_s))
      page_ids << id.to_s
      self.next_page = true
    else
      self.next_page = false
    end
    save!
    id.nil?
  end

  def pages
    @contents ||= page_ids.map do |id|
      begin
        Exercise.find(id)
      rescue
        Introduction.find(id)
      end
    end
    @contents
  end

  def pages_count
    pages.size
  end

  def pages_with_name
    i, e, page_count, index = 0, 0, 0, -1

    pages.map do |page|
      if page.instance_of? Introduction
        i += 1
        page_count = i
      else
        e += 1
        page_count = e
      end
      index += 1
      { page_name: "#{page.class.model_name.human} #{page_count}: #{page.title}",
        type: page.class.to_s.downcase,
        page_collection: index
      }
    end
  end

  private
    def insert_introduction_pages
         self.page_ids += lo.introductions.pluck(:id)          
    end

  def insert_first_exercise
         st = Sequence::Statistic.where(lo_id: lo_id).last
         self.create_exercises_ordering statistic_id: st.id
         id = self.exercises_ordering.nextExercise
         self.page_ids << id.to_s
         self.next_page = true
         save
  end
end
