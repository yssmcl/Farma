class Answers::Lo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from_id, type: Moped::BSON::ObjectId
  field :name, type: String
  field :description, type: String

  belongs_to :soluction, class_name: "Answers::Soluction",  inverse_of: :lo

  validates_presence_of :from_id, :name, :description

  index({ name: 1}, { unique: true })

  def self.create_from(original_lo, soluction)
    lo = Answers::Lo.new from_id: original_lo.id,
                         name: original_lo.name,
                         description: original_lo.description,
                         soluction_id: soluction.id
    lo.save!
    lo
  end
end
