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

  # TODO: tirar o begin-end e o rescue
  # Retorna somente as IDs das introduções do array ids
  def find_introductions(ids)
    a = []
    ids.each do |id|
      begin
        item = Introduction.find(id)
        a << item.id
      rescue
      end
    end
    return a
  end

  # Realizar calculos do auto sequenciamento aqui
  def calculates
    #debugger
    self.next_page = true
    id = exercises_ordering.nextExercise()
    logger.info "#{Time.now} === page_ids: #{findd(page_ids)}"

    if not(page_ids.include?(id.to_s))
      prerequisites = Exercise.find(id).introduction_ids
      # TODO: Checar se prerequisites é vazio para, em vez de concatenar [] no page_ids, concatenar o resto das introduções que ainda não foram vistas? Se sim, escrever isso na monografia.
      logger.debug "#{Time.now} === pre-requisitos de #{findd(id.to_a)}: #{findd(prerequisites)}"

      viewed_introductions = find_introductions(page_ids)
      logger.debug "#{Time.now} === Introducoes vistas: #{findd(viewed_introductions)}"

      # Pega as páginas não comuns entre as páginas que já foram vistas e as que são pré-requisitos para o próximo exercício
      # introductions_to_be_viewed = prerequisites - viewed_introductions | viewed_introductions - prerequisites
      prerequisites = prerequisites - viewed_introductions
      logger.debug "#{Time.now} === Introducoes a serem vistas: #{findd(prerequisites)}"

      page_ids.concat(prerequisites)
      page_ids << id.to_s
      logger.debug "#{Time.now} === Novas paginas: #{findd(page_ids)}\n"

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

      if exercise.introductions.empty?
        self.page_ids += lo.introductions.pluck(:id)
      else
        self.page_ids += exercise.introductions.pluck(:id)
      end
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
