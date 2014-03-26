require 'spec_helper'

describe Answers::Lo do

  before do
    @uflo = FactoryGirl.create(:user)
    @original_lo = FactoryGirl.create(:lo, user: @uflo)
  end

  let(:user) { @user = FactoryGirl.create(:user) }

  subject { @answers_lo = Answers::Lo.new }

  it { should respond_to(:from_id) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should belongs_to(:soluction) }

  describe "Answers::Lo validations" do
    before do
      @lo = Answers::Lo.create
    end

    it { should have(1).error_on(:from_id) }
    it { should have(1).error_on(:name) }
    it { should have(1).error_on(:description) }
  end

  describe "Copy Lo, used when a soluction is create" do

    it "should copy the lo attributes" do 
      answers_lo = Answers::Lo.create_from(@original_lo, Answers::Soluction.new)
      answers_lo.reload

      answers_lo.from_id.should eql(@original_lo.id)
      answers_lo.name.should eql(@original_lo.name)
      answers_lo.description.should eql(@original_lo.description)
    end

  end
end

