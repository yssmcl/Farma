require 'spec_helper'

describe Answers::Exercise do

    before do
      @lo = FactoryGirl.create(:lo, :with_introductions_and_exercises)
      @oe = @lo.exercises.first # oe = orginal exercise
    end

    it { should respond_to(:from_id) }
    it { should respond_to(:title) }
    it { should respond_to(:content) }

    it { should has_many :questions}
    it { should belongs_to :soluction}

    describe "Copy Exer, used when a soluction is create" do

      before do
        @ae = Answers::Exercise.create_from(@oe, Answers::Soluction.new)
        @ae.reload
      end

      it "should copy the exercise attributes" do 
        @ae.from_id.should eql(@oe.id)
        @ae.title.should eql(@oe.title)
        @ae.content.should eql(@oe.content)
      end

      it "should copy the questions" do 
        @ae.questions.size.should eql(@oe.questions.size)
      end
    end
end
