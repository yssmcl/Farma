require 'spec_helper'

describe Answers::LastAnswer do

    before { @last_answer = Answers::LastAnswer.new }

    subject { @last_answer }

    it { should belongs_to(:question) }
    it { should belongs_to(:answer) }
end
