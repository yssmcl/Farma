require 'spec_helper'

describe Lo do

  it {should respond_to(:questions_available_count) }

  describe "When Lo is shared" do
    let(:lo) { FactoryGirl.create(:lo) }
    let(:user) { FactoryGirl.create(:user) }

    it "should return a shared status" do
      RequestLo.request(lo.id).to(user)

      lo.shared_status_for(user).should eql("waiting")
    end
  end
end

#  describe "Available questions cache counter" do
#    before do
#      @lo = FactoryGirl.create(:lo, :with_introductions_and_exercises, user: @user_admin)
#    end
#
#    it "should be increment when a question is create" do
#      @lo.questions_available_count.should == 9
#    end
#
#    it "should be increment when a question available changes to true"
#
#    it "should be decrement when a question is destroy" do
#      @lo.exercises.first.questions.first.destroy
#      @lo.questions_available_count.should == 8
#    end
#
#    it "should be decrement when all questions are destroyed" do
#      @lo.exercises.first.questions.destroy_all
#      @lo.reload
#      @lo.questions_available_count.should == 6
#    end
#
#    it "should be decrement when the exercises are destroyed", focus: true do
#      @lo.exercises.destroy_all
#      @lo.reload
#      @lo.questions_available_count.should == 0
#    end
#
#    it "should be decrement when a question available changes to false"
#  end


