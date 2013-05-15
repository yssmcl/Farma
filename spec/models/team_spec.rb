require 'spec_helper'

describe Team do

  before(:each) do
    @ids = []
    @user = FactoryGirl.create(:user, admin: false)
    @user_a = FactoryGirl.create(:user, admin: false)

    2.times do
      team = FactoryGirl.create(:team, owner_id: @user.id)
      @ids.push team.id
    end

    team = FactoryGirl.create(:team, owner_id: @user_a.id)
    team_b = FactoryGirl.create(:team, owner_id: @user_a.id)

    team.enroll(@user, '1234')
    @ids.push team.id
  end

  it "should return owner team ids and enroll team_ids from a specific user" do
     Team.ids_by_user(@user).should eql(@ids)
  end

end
