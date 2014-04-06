require 'spec_helper'

describe Answers::Exercise do

  subject { @exercise = Answers::Exercise.new }

  it { should respond_to(:from_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }

  it { should embeds_many :questions}
  it { should embedded_in :soluction}
end
