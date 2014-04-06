require 'spec_helper'

describe Answers::Question do

  subject { @answers_lo = Answers::Question.new }

  it { should respond_to(:from_id) }
  it { should respond_to(:soluction_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:correct_answer) }
  it { should respond_to(:position) }
  it { should respond_to(:exp_variables) }
  it { should respond_to(:many_answers) }
  it { should respond_to(:eql_sinal) }
  it { should respond_to(:cmas_order) }
  it { should respond_to(:precision) }

  it { should has_many(:retroaction_answers) }
  it { should embedded_in(:exercise) }
  it { should embeds_many(:tips) }
  it { should embeds_one(:last_answer) }
end
