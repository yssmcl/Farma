require 'spec_helper'

describe Answer do

  before(:each) do
    @user_admin = FactoryGirl.create(:user, admin: true)
    @user = FactoryGirl.create(:user, admin: false)
    @lo = FactoryGirl.create(:lo, user: @user_admin)
    @exercise = FactoryGirl.create(:exercise, lo: @lo)
    @question = FactoryGirl.create(:question, exercise: @exercise)
    @team = FactoryGirl.create(:team, owner_id: @user_admin.id)

    2.times do
      create_valid_answers()
      create_invalid_answers()
    end
  end

  it "should see only valid answers (team_id != nil and for_test == false)" do
    Answer.every.should have(2).items
  end

  it "should see only valid wrong answers" do
    Answer.wrong.should have(2).items
  end

  it "should see only valid correct answers" do
    Answer.corrects.should have(0).items
  end

  it "should see any answers when all answers" do
    Answer.all.should have(4).items
  end

  it "when search as admin should see all answers that is not for test" do
    Answer.search({}, @user_admin).should have(2).items
  end

  it "when search as a regular user I should see my answers" do
    user = FactoryGirl.create(:user, admin: false)
    @team.enroll(user, '1234')

    2.times { create_valid_answers(user) }
    Answer.search({user_id: user.id}, user).should have(2).items
  end

  it "when search as a regular user I should see own answers and wrongs answers from other users" do
    user = FactoryGirl.create(:user, admin: false)
    user_a = FactoryGirl.create(:user, admin: false)
    @team.enroll(user, '1234')
    @team.enroll(user_a, '1234')

    create_valid_answers(user)
    create_valid_answers(user, 'x + 1')

    2.times { create_valid_answers(user_a, 'x + 1') }

    Answer.search({}, user).should have(4).items
  end

  it "when a ower of a turm search a answer it can see the correct and wrongs answers" do
    user = FactoryGirl.create(:user, admin: false)
    user_a = FactoryGirl.create(:user, admin: false)
    team = FactoryGirl.create(:team, owner_id: user.id)

    team.enroll(user_a, '1234')
    2.times { create_valid_answers(user_a, 'x + 1', team.id) } # corrects
    2.times { create_valid_answers(user_a, 'x + 10', team.id) } # wrongs

    Answer.search({}, user).should have(4).items
  end

  it "when a search of user, I should see only users answer", focus: true do
    user_a = FactoryGirl.create(:user, admin: false)

    2.times { create_valid_answers(user_a, 'x + 1') } # corrects
    2.times { create_valid_answers(user_a, 'x + 10') } # wrongs

    Answer.search_of_user(user_a, {}).should have(4).items
  end

  it "when a search of user in teams, He should see only answer of your collegues", focus: true do
    user = FactoryGirl.create(:user, admin: false)
    user_a = FactoryGirl.create(:user, admin: false)
    team = FactoryGirl.create(:team, owner_id: user.id)

    team.enroll(user_a, '1234')
    team.enroll(user, '1234')
    2.times { create_valid_answers(user_a, 'x + 1', team.id) } # corrects
    2.times { create_valid_answers(user_a, 'x + 10', team.id) } # wrongs

    Answer.search_in_teams_enrolled(user).should have(4).items
    Answer.search_in_teams_enrolled(user_a).should have(0).items
  end

private
  def create_valid_answers(user = @user, response = 'x', team_id = @team.id)
      FactoryGirl.create(:answer,
                         lo_id: @lo.id,
                         exercise_id: @exercise.id,
                         question_id: @question.id,
                         team_id: team_id,
                         response: response,
                         user: user,
                         for_test: false
                        )
  end

  def create_invalid_answers(number = 0, user = @user)
      FactoryGirl.create(:answer,
                         lo_id: @lo.id,
                         exercise_id: @exercise.id,
                         question_id: @question.id,
                         team_id: @team.id,
                         response: "x",
                         user: user,
                         for_test: true
                        )
  end


end
