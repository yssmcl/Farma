require 'spec_helper'

describe Question do
  
  before(:each) do
    @user_admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user)
    @lo = FactoryGirl.create(:lo, user: @user_admin)
    @exercise = FactoryGirl.create(:exercise, lo: @lo)
    @question = FactoryGirl.create(:question, exercise: @exercise)
  end

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:correct_answer) }
  it { should respond_to(:available) }
  it { should respond_to(:cmas_order) }
  it { should respond_to(:position) }
  it { should respond_to(:precision) }
  it { should respond_to(:exp_variables) }
  it { should respond_to(:many_answers) }
  it { should respond_to(:eql_sinal) }

  it { should belongs_to(:exercise) }
  it { should has_many(:tips) }
  it { should has_many(:tips_counts) }
  it { should has_many(:last_answers) }

  it "should return a appropriate tip" do
    ref_tip = @question.tips.last
    tips = @question.tips_for(2)

    tips.last.content.should eql(ref_tip.content)
    tips.size.should eql(2)
  end

  it "should not have more then 3 multiple answers" do
    question = Question.new correct_answer: "10;20;30;10"
    question.valid?
    question.errors[:correct_answer].should_not  be_empty
  end

  it "should not have multiple answers equivalents when cmas_oder is false" do
    question = Question.new correct_answer: "10;10;30", cmas_order: false
    question.valid?
    question.errors[:correct_answer].should_not  be_empty
  end

  it "can have multiple answers equivalents when cmas_oder is true" do
    question = Question.new correct_answer: "10;10;30", cmas_order: true
    question.valid?
    question.errors[:correct_answer].should  be_empty
  end
end
