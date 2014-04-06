require 'spec_helper'

describe Answers::Tip do

  subject { @tip =  FactoryGirl.build(:answers_tip) }

  it { should respond_to(:from_id) }
  it { should respond_to(:content) }
  it { should respond_to(:number_of_tries) }

  it { should embedded_in(:question) }
end
