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

  it { should embedded_in(:soluction) }

  describe "Answers::Lo validations" do
    before do
      @lo = Answers::Lo.create
    end

    it { should have(1).error_on(:from_id) }
    it { should have(1).error_on(:name) }
    it { should have(1).error_on(:description) }
  end

end

