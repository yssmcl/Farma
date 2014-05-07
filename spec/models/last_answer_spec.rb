require 'spec_helper'

describe LastAnswer do

  let(:user) { @user = FactoryGirl.create(:user) }

  before(:each) do
    @user_admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user)

    @lo = FactoryGirl.create(:lo, user: @user_admin)
    @exercise = FactoryGirl.create(:exercise, lo: @lo)
    @question = FactoryGirl.create(:question, exercise: @exercise)

    @team = FactoryGirl.create(:team)
    @team.lo_ids << @lo.id
    @team.enroll(@user, '1234')
  end

  it "should return last user answer from a question" do
    params = {response: 10, from_question_id: @question.id, team_id: @team.id}
    soluction = user.answers.create(params)

    answer = LastAnswer.answer_where(user_id: user.id,
                                     question_id: @question.id,
                                     team_id: @team.id)

    answer.id.should eql(soluction.id)
    answer.response.should eql(soluction.response)
  end

  it "should return nil if there is no last user answer from a question" do
    answer = LastAnswer.answer_where(user_id: user.id,
                                     question_id: @question.id,
                                     team_id: @team.id)
    answer.should be_nil
  end

end
