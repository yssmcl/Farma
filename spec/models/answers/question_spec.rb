require 'spec_helper'

describe Answers::Question do

  before { @soluction = Answers::Soluction.new }
  subject { @answers_lo = Answers::Question.new }

  it { should respond_to(:from_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:correct_answer) }
  it { should respond_to(:position) }
  it { should respond_to(:exp_variables) }
  it { should respond_to(:many_answers) }
  it { should respond_to(:eql_sinal) }

  it { should belongs_to(:soluction) }
  it { should belongs_to(:exercise) }
  it { should has_many(:tips) }
  it { should have_one(:last_answer) }

  describe "Copy Question, used when a soluction is create" do
    before do
      user = FactoryGirl.create(:user)
      @oq = FactoryGirl.create(:question) # original question

      @soluction = user.answers.create from_question_id: @oq.id,
                                       response: "x + 1" 
    end

    it "should copy the Question attributes" do
      @soluction.question.soluction_id.should eql(@soluction.id)
      @soluction.question.from_id.should eql(@oq.id)
      @soluction.question.title.should eql(@oq.title)
      @soluction.question.content.should eql(@oq.content)
      @soluction.question.correct_answer.should eql(@oq.correct_answer)
      @soluction.question.position.should eql(@oq.position)
      @soluction.question.exp_variables.should eql(@oq.exp_variables)
      @soluction.question.many_answers.should eql(@oq.many_answers)
      @soluction.question.eql_sinal.should eql(@oq.eql_sinal)
    end

    it "should copy the Question tips" do
      @soluction.question.tips.map(&:from_id).should eql(@oq.tips.map(&:id))
      @soluction.question.tips.map(&:content).should eql(@oq.tips.map(&:content))
      @soluction.question.tips.map(&:number_of_tries).should eql(@oq.tips.map(&:number_of_tries))
    end
  end
end
