require 'spec_helper'

describe RequestLo do
  let(:lo) { FactoryGirl.create(:lo, :with_introductions_and_exercises) }
  let(:user) { FactoryGirl.create(:user) }

  before {@request = lo.requests.create!(user_from: user.id) }

  describe "Request for a lo" do

    subject { @request }

    its(:lo_id) { eql(lo.id) }
    its(:user_to) { eql(lo.user) }
    its(:user_from) { eql(user) }

    it "should have a request method" do
      expect do
        RequestLo.request(lo.id).to(user)
      end.to change(RequestLo, :count).by(1)
    end
  end

  describe "authorize request should deep clone the lo" do
    it "should increment the user from los by 1" do
       expect{@request.authorize}.to change(user.los, :count).by(1)
    end

    describe "clone lo" do
      before do
        @request.authorize
        @clone = user.los.last
      end

      it { expect(@clone.copy_from).to eql(lo) }
      it { expect(@clone.introductions).to have_exactly(lo.introductions.count).items }
      it { expect(@clone.exercises).to have_exactly(lo.exercises.count).items }

      it "have the sames questions" do
        @clone.exercises.each do |exercise|
          expect(exercise.questions).to have_exactly(3).items
        end
      end

      it "have the sames tips" do
        @clone.exercises.each do |exercise|
          exercise.questions.each do |question|
            expect(question.tips).to have_exactly(3).items
          end
        end
      end
    end
  end
end

