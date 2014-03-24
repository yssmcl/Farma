require 'spec_helper'

describe Answers::Soluction, focus: true do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @user_admin = FactoryGirl.create(:admin)
    @lo = FactoryGirl.create(:lo, user: @user_admin)
    @exercise = FactoryGirl.create(:exercise, lo: @lo)
    @question = FactoryGirl.create(:question, exercise: @exercise)
    @team = FactoryGirl.create(:team, owner_id: @user_admin.id)
    @soluction = Answers::Soluction.new
  end

  subject { @soluction }

  it { should respond_to(:from_question_id) }
  it { should respond_to(:response) }
  it { should respond_to(:correct?) }
  it { should respond_to(:attempt_number) }
  it { should respond_to(:to_test) }

  it { should have_one(:lo) }
  it { should have_one(:question) }
  it { should have_one(:exercise) }
  it { should belongs_to(:team) }

  describe "Answers::Soluction association" do
    it "should have one lo with dependet destroy" do
      answer_lo = Answers::Lo.create_from(@lo, @soluction)
      @soluction.lo = answer_lo
      @soluction.destroy.should be_true
      expect { answer_lo.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  describe "Copy of soluction context" do
    before do
      params = {response: 10, from_question_id: @question.id}
      @soluction = user.answers.create(params)
      @soluction.reload
    end

    it "should copy the Lo" do
      @soluction.lo.from_id.should eql(@lo.id)
    end

    it "should copy the Question" do
      @soluction.from_question_id.should eql(@question.id)
      @soluction.question.from_id.should eql(@question.id)
    end

    it "should copy the Exercise" do
      @soluction.exercise.from_id.should eql(@question.exercise.id)
    end

    it "should copy the questions's last answers" do
      team = FactoryGirl.create(:team, owner_id: user.id)
      team.enroll(user, '1234')
      question = FactoryGirl.create(:question)

      a = user.answers.create from_question_id: question.id,
                              response: "x + 1", team_id: team.id

      cq = a.exercise.questions.where(from_id: question.id).first

      cla = cq.last_answer
      ola = question.last_answer(user)

      ola.answer.id.should eql(cla.answer.id)
      ola.answer.response.should eql(cla.answer.response)
    end
  end

  describe "Verify response" do

    it "should set correct attribute as true when a correct response is send" do
      answer = user.answers.create from_question_id: @question.id,
        response: "x + 1"
      answer.correct?.should be_true
    end

    it "should set correct attribute as false when a wrong response is send" do
      answer = user.answers.create from_question_id: @question.id,
        response: "x + 10"
      answer.correct?.should be_false
    end

    it "should set a tip after wrong response" do
      answer = user.answers.create from_question_id: @question.id,
        response: "x + 10"
      answer.attempt_number.should == 1
      answer.tips.size.should == 1
      answer.tips.first.content.should eql(@question.tips.last.content)
    end
  end

  describe "Search answers" do
    before do
      user.answers.create from_question_id: @question.id, to_test: true,
        response: "x + 2", team_id: @team.id
      2.times do
        create_valid_answer(user)
        user.answers.create from_question_id: @question.id,
          response: "x + 2", team_id: @team.id
      end

      @user_a = FactoryGirl.create(:user, admin: false)
      @user_b = FactoryGirl.create(:user, admin: false)
      @team = FactoryGirl.create(:team, owner_id: user.id)

      @team.enroll(@user_a, '1234')
      @team.enroll(@user_b, '1234')
    end

    it "should see only valid answers (team_id != nil and to_test == false)" do
      Answers::Soluction.every.should have(4).items
    end

    it "should see only valid wrong answers" do
      Answers::Soluction.wrong.should have(2).items
    end

    it "should see only valid correct answers" do
      Answers::Soluction.corrects.should have(2).items
    end

    it "should see any answers when all answers" do
      Answers::Soluction.all.should have(5).items
    end

    it "does search as a regular user I should see his answers" do
      2.times { create_valid_answer(@user_a) }
      Answers::Soluction.search_of_user(@user_a).should have(2).items
    end

    it "does search as a regular user He should see own answers and wrongs answers from other users" do
      4.times { create_valid_answer(@user_a, "10") }

      Answers::Soluction.search_in_teams_enrolled(@user_b).should have(4).items
    end

    it "when a ower of a turm search a answer it can see the correct and wrongs answers" do
      2.times { create_valid_answer(@user_a) } # corrects
      2.times { create_valid_answer(@user_a, '10') } # wrongs

      Answers::Soluction.search_in_teams_created(user).should have(4).items
    end

    it "when a user search his answer, I should see only users answer" do

      2.times { create_valid_answer(@user_a) } # corrects
      2.times { create_valid_answer(@user_a, '10') } # wrongs

      Answers::Soluction.search_of_user(@user_a, {}).should have(4).items
    end

    it "when a user search in teams, he should see only answer of your collegues" do

      2.times { create_valid_answer(@user_a) } # corrects
      2.times { create_valid_answer(@user_a, 'x + 10') } # wrongs

      Answers::Soluction.search_in_teams_created(user).should have(4).items
      Answers::Soluction.search_in_teams_enrolled(@user_a).should have(0).items
    end
  end

  describe "Delete Answers::Soluction" do
    it "when delete Answers::Slouction should delete dependents" do
      2.times {create_valid_answer(user)} # corrects
      2.times {create_valid_answer(user, response = "x")} # wrongs

      Answers::Soluction.destroy_all

      Answers::Lo.count.should eql(0)
      Answers::Exercise.count.should eql(0)
      Answers::Question.count.should eql(0)
      Answers::Tip.count.should eql(0)
      Answers::LastAnswer.count.should eql(0)
    end
  end

  #helpers
  def create_valid_answer(user, response = "x + 1")
    user.answers.create from_question_id: @question.id,
      response: response, team_id: @team.id
  end
end
