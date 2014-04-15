require 'spec_helper'

describe Reports::LearnerReport do

  it { should respond_to(:percentage_completed) }
  it { should respond_to(:user_id) }
  it { should respond_to(:team_id) }
  it { should respond_to(:lo_id) }

  it { should belongs_to (:user) }
  
  describe "Calculate Percentege of LO exercises completeness" do
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      @user_admin = FactoryGirl.create(:admin)
      @lo = FactoryGirl.create(:lo, user: @user_admin)
      @exercise = FactoryGirl.create(:exercise, lo: @lo)
      @question = FactoryGirl.create(:question, exercise: @exercise)
      @team = FactoryGirl.create(:team, owner_id: @user_admin.id)
      
      @team.los << @lo
      @team.enroll user, '1234'
    end

    it "for intial Lo the completeness should be zero" do
      user.completeness_of(@team, @lo).should eql(0.0)
    end

    it "should increment completeness when a right answer is send" do
      user.answers.create from_question_id: @question.id,
                          response: "x+1", team_id: @team.id

      user.completeness_of(@team, @lo).should eql(25.0)
    end

    it "should not increment completeness when the answer sent is wrong" do
      user.answers.create from_question_id: @question.id,
                          response: "1", team_id: @team.id

      user.completeness_of(@team, @lo).should eql(0.0)
    end
  end
 end

