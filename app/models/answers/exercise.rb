class Answers::Exercise
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :title, type: String
  field :content, type: String

  has_many :questions, class_name: "Answers::Question", inverse_of: :exercise, dependent: :delete
  belongs_to :soluction, class_name: "Answers::Soluction",  inverse_of: :exercise

  validates_presence_of :title, :content

  # Create Answers::Exercise from other exercise
  def self.create_from(original_exercise, soluction)
    exercise = Answers::Exercise.new from_id: original_exercise.id,
                                     title:   original_exercise.title,
                                     content: original_exercise.content,
                                     soluction_id: soluction.id

    exercise.save!
    copy_questions(exercise, original_exercise)
    exercise
  end

private
  def self.copy_questions(exercise, original_exercise)
    original_exercise.questions.each do |question|
      Answers::Question.copy_for_exercise(question, exercise)
    end
  end
end
