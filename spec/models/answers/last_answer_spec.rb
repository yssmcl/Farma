require 'spec_helper'

describe Answers::LastAnswer do

    subject { @last_answer = Answers::LastAnswer.new }

    it { should respond_to(:response) }
    it { should respond_to(:correct) }
    it { should respond_to(:attempt_number) }

    it { should embedded_in(:question) }
end
