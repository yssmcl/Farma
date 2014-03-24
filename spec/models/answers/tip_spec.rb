require 'spec_helper'

describe Answers::Tip do

  subject { @tip = Answers::Tip.new }

  it { should respond_to(:from_id) }
  it { should respond_to(:content) }
  it { should respond_to(:number_of_tries) }

  it { should belongs_to(:question) }
end
