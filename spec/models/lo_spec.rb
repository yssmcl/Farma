require 'spec_helper'

describe Lo do
  describe "When Lo is shared" do
    let(:lo) { FactoryGirl.create(:lo) }
    let(:user) { FactoryGirl.create(:user) }

    it "should return a shared status" do
      RequestLo.request(lo.id).to(user)

      lo.shared_status_for(user).should eql("waiting")
    end
  end
end
