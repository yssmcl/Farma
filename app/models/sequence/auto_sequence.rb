class Sequence::AutoSequence
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :team_id, type: Moped::BSON::ObjectId
  field :page_ids, type: Array, default: []
  field :next_page, type: Boolean, default: false
  field :viewed_introductions, type: Array, default: []

  embeds_one :exercises_ordering, class_name: "Sequence::ExercisesOrdering", inverse_of: :auto_sequence

  def lo
    @lo ||= Lo.find(self.lo_id)
  end

  def user
    @user ||= User.find(self.user_id)
  end

  # TODO: after_create ou before_create?
  # before_create :insert_introduction_pages
  # after_create :insert_first_exercise
  after_create :insert_introduction_pages, :insert_first_exercise

  # TODO: função de teste
  def findd(ids)
    a = []
    ids.each do |id|
      begin
        item = Introduction.find(id)
      rescue
        item = Exercise.find(id).questions.first
      end
      a << item.title
    end
    return a
  end

  # Realizar calculos do auto sequenciamento aqui
  def calculates
    #debugger
    self.next_page = true
    id = exercises_ordering.nextExercise()
    logger.debug "#{Time.now} === page_ids sem nada: #{findd(page_ids)}"

    if not(page_ids.include?(id.to_s))
      prerequisites = Exercise.find(id).introduction_ids

      # Pega as páginas não comuns entre as páginas que já foram vistas e as que são pré-requisitos para o próximo exercício
      introductions_to_be_viewed = prerequisites - viewed_introductions | viewed_introductions - prerequisites
      introductions_to_be_viewed = introductions_to_be_viewed - page_ids
      logger.debug "#{Time.now} === pre-requisitos de #{findd(id.to_a)}: #{findd(prerequisites)}"
      logger.debug "#{Time.now} === Introducoes vistas: #{findd(viewed_introductions)}"
      logger.debug "#{Time.now} === Introducoes a serem vistas: #{findd(introductions_to_be_viewed)}"

      page_ids.concat(introductions_to_be_viewed)
      page_ids << id.to_s
      logger.debug "#{Time.now} === Novas paginas: #{findd(page_ids)}"

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
    # def insert_introduction_pages
    #   self.page_ids += lo.introductions.pluck(:id)
    # end
 
    def insert_introduction_pages
      st = Sequence::Statistic.where(lo_id: lo_id).last
      self.create_exercises_ordering(statistic_id: st.id)
      exercise_id = self.exercises_ordering.nextExercise
      exercise = Exercise.find(exercise_id)
      self.page_ids += exercise.introductions.pluck(:id)
      self.viewed_introductions = self.page_ids
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
