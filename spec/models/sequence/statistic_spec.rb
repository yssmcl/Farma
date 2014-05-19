require 'spec_helper'

describe Statistic do
  
  before(:each) do
   # system('mongorestore --db carrie_test /home/romulo/Farma/projetos/Farma/spec/data/farma_production_2014_3')
   # puts " numero de alunos: #{User.count}"
    @user_admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user)
    @lo = FactoryGirl.create(:lo, :with_introductions_and_exercises, user: @user_admin)
    @team = FactoryGirl.create(:team, owner_id: @user_admin.id)
    @team.los.push(@lo)
     @user1 = FactoryGirl.create(:user)
     @user2 = FactoryGirl.create(:user)
     @user3 = FactoryGirl.create(:user)
     @user4 = FactoryGirl.create(:user)
     @team.enroll(@user1, "1234")
     @team.enroll(@user2, "1234")
     @team.enroll(@user3, "1234")
     @team.enroll(@user4, "1234")
    
     @question = @lo.exercises.first.questions.first
     @lo.exercises.each do |exercise|
         exercise.questions.each do |question|
             params1 = {response: 10, from_question_id: question.id, team_id: @team.id}
             params2 = {response: 'x+1', from_question_id: question.id, team_id: @team.id}
             @user1.answers.create(params1)
             @user2.answers.create(params2)
             @user3.answers.create(params2)
             @user4.answers.create(params1)
             
         end
     end
  end



  it { should respond_to(:question_statistics) }

    #lo_id = Moped::BSON::ObjectId.from_string("52729c94759b7412000008b1")
    #team_id = Moped::BSON::ObjectId.from_string("531876be759b7401c3000437")

  it "should calculate statistics" do
    statistic = Statistic.new lo_id: @lo.id , team_id: @team.id 
    statistic.calculate_statistics
    #statistic.median.should == 1

  end

 end