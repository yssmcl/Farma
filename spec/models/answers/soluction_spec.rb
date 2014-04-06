require 'spec_helper'

describe Answers::Soluction do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @user_admin = FactoryGirl.create(:admin)
    @lo = FactoryGirl.create(:lo, user: @user_admin)
    @exercise = FactoryGirl.create(:exercise, lo: @lo)
    @question = FactoryGirl.create(:question, exercise: @exercise)
    @team = FactoryGirl.create(:team, owner_id: @user_admin.id)

    @soluction = FactoryGirl.build(:soluction)
  end

  subject { @soluction }

  it { should respond_to(:from_question_id) }
  it { should respond_to(:response) }
  it { should respond_to(:correct?) }
  it { should respond_to(:attempt_number) }
  it { should respond_to(:to_test) }

  it { should embeds_one(:lo) }
  it { should embeds_one(:exercise) }
  it { should belongs_to(:team) }

  describe "Copy of soluction context" do
    before do
      params = {response: 10, from_question_id: @question.id}
      @soluction = user.answers.create(params)
      @soluction.reload
    end

    it "should copy the Lo" do
      @soluction.lo.from_id.should eql(@lo.id)
    end

    it "should copy the Exercise" do
      @soluction.exercise.from_id.should eql(@question.exercise.id)
      @soluction.exercise.title.should eql(@question.exercise.title)
      @soluction.exercise.content.should eql(@question.exercise.content)
    end

    it "should copy the exercise questions" do
      o_qs = @question.exercise.questions
      s_qs = @soluction.exercise.questions

      s_qs.count.should eql(o_qs.count)

      s_qs.each_with_index do |s_q,i|
        s_q.from_id.should        eql(o_qs[i].id)
        s_q.content.should        eql(o_qs[i].content)
        s_q.correct_answer.should eql(o_qs[i].correct_answer)
        s_q.position.should       eql(o_qs[i].position)
        s_q.exp_variables.should  eql(o_qs[i].exp_variables)
        s_q.many_answers.should   eql(o_qs[i].many_answers)
        s_q.eql_sinal.should      eql(o_qs[i].eql_sinal)
        s_q.cmas_order.should     eql(o_qs[i].cmas_order)
        s_q.precision.should      eql(o_qs[i].precision)
      end
    end

    it "should copy the questions tips" do
      o_qs = @question.exercise.questions
      s_qs = @soluction.exercise.questions

      s_qs.each_with_index do |s_q,i|
        oq_tips = o_qs[i].tips
        s_q.tips.count.should eql(oq_tips.count)

        s_q.tips.each_with_index do |s_tip, j|
          s_tip.from_id.should eql(oq_tips[j].id)
          s_tip.content.should eql(oq_tips[j].content)
          s_tip.number_of_tries.should eql(oq_tips[j].number_of_tries)
        end
      end
    end

    it "should copy the questions last answer" do
      o_qs = @question.exercise.questions
      s_qs = @soluction.exercise.questions

      s_qs.each_with_index do |s_q,i|
        if la = o_qs[i].last_answer(user)
          s_q.last_answer.response.should       eql(la.answer.response)
          s_q.last_answer.correct.should        eql(la.answer.correct)
          s_q.last_answer.attempt_number.should eql(la.answer.attempt_number)
        end
      end
    end

    it "should set question answered" do
      @soluction.question.from_id.should        eql(@question.id)
      @soluction.question.content.should        eql(@question.content)
      @soluction.question.correct_answer.should eql(@question.correct_answer)
      @soluction.question.position.should       eql(@question.position)
      @soluction.question.exp_variables.should  eql(@question.exp_variables)
      @soluction.question.many_answers.should   eql(@question.many_answers)
      @soluction.question.eql_sinal.should      eql(@question.eql_sinal)
      @soluction.question.cmas_order.should     eql(@question.cmas_order)
      @soluction.question.precision.should      eql(@question.precision)
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
      user.answers.create from_question_id: @question.id, to_test: true,
        response: "x + 2", team_id: nil 

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
      Answers::Soluction.all.should have(6).items
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

  #helpers
  def create_valid_answer(user, response = "x + 1")
    user.answers.create from_question_id: @question.id,
      response: response, team_id: @team.id
  end
end
