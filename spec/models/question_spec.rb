require 'spec_helper'

describe Question do
  
  before(:each) do
    @user_admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user)
    @lo = FactoryGirl.create(:lo, user: @user_admin)
    @exercise = FactoryGirl.create(:exercise, lo: @lo)
    @question = FactoryGirl.create(:question, exercise: @exercise)
  end

  it "should return a appropriate tip" do
    ref_tip = @question.tips.last
    tips = @question.tips_for(2)

    tips.last.content.should eql(ref_tip.content)
    tips.size.should eql(2)
  end
end
