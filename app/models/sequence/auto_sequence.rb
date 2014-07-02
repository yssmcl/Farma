class Sequence::AutoSequence
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: Moped::BSON::ObjectId
  field :lo_id, type: Moped::BSON::ObjectId
  field :team_id, type: Moped::BSON::ObjectId
  field :page_ids, type: Array, default: []
  field :next_page, type: Boolean, default: false

  def lo
    @lo ||= Lo.find(self.lo_id)
  end

  def user
    @user ||= User.find(self.user_id)
  end

  # Realizar calculos do auto sequenciamento aqui
  def calculates
    self.next_page = false
    id = lo.exercises.sample.id
    if not(page_ids.include?(id)) && user.answers.last.correct?
      page_ids << id
      self.next_page = true
    end
    save!
    self
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
end
