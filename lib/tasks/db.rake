namespace :db do

  desc "fix database because tipsCounts for test answers"
  task :fixed_tips_count => :environment do
    LastAnswer.each do |la|
      if la.answer.nil?
        la.destroy
        next
      end
      # update last answer team_id
      team_id = la.answer.team_id
      la.set(:team_id, team_id)
    end
    TipsCount.each do |tc|
      if tc.user.nil?
        tc.destroy
        next
      end
      answer = Answers::Soluction.where(from_question_id: tc.question.id,
                                        user_id: tc.user.id).last
      if answer.nil?
        tc.destroy
        next
      end
      tc.set(:team_id, answer.team_id)
    end
  end

  desc "fixe lo.from_id for each answer"
  task :fixed_lo_id_for_answer => :environment do
    Answers::Soluction.every.each do |answer|
      question = Question.find(answer.from_question_id)
      if answer.lo
        answer.lo.update_attribute(:from_id, question.exercise.lo.id)
      end
    end
  end

  desc "update team available attribute"
  task :update_teams_available => :environment do
    Team.each {|t| t.update_attribute(:available, true)}
  end

  desc "created learners progress"
  task :create_progress => :environment do
    Answers::Soluction.corrects.each do |ans|
      rts = Reports::LearnerReport.find_or_create_by user_id: ans.user_id,
        team_id: ans.team_id,
        lo_id: ans.original_question.exercise.lo.id
      rts.calculate
    end
  end

  desc "Clear temporary data of answers"
  task :clear_tmp_data => :environment do
     answers = Answers::Soluction.or({team_id: nil}, {to_test: true})
     answers.destroy_all
     TipsCount.where(team_id: nil).destroy_all
     User.where(guest: true).destroy_all
  end


  #==============================================
  desc "This populate database"
  task :populate => :environment do
    require 'faker'

    [Lo, User, Team, LastAnswer, TipsCount, Answer, RetroactionAnswer].each(&:destroy_all)

    professor = User.create!(name: 'Farma', email: 'farma.ufpr@gmail.com', password: 'farma123',
                password_confirmation: 'farma123', admin: true)

    los = 10.times.map do
        lo = professor.los.create( name: Faker::Name.name, available: true,
                                   description: Faker::Lorem.paragraphs(2).join)
        3.times do
          lo.introductions.create( title: Faker::Name.title, content: Faker::Lorem.paragraphs(3).join)
        end

        3.times do
          exer = lo.exercises.create( title: Faker::Name.title, content: Faker::Lorem.paragraphs(3).join)
          3.times do |i|
            q = exer.questions.create(title: Faker::Name.title, content: Faker::Lorem.paragraphs(1).join,
                                  correct_answer: i)

            3.times do |o|
              q.tips.create(content: Faker::Lorem.paragraphs(1).join,
                            numbers_of_tries: o )
            end

          end
        end
    end

    lo_ids = Lo.all.map {|l| l.id}
    35.times do |i|
      team = Team.create!(name: "Turma #{i}", code: "1234", owner_id: User.first.id)
      team.user_ids << professor.id
      team.lo_ids << lo_ids.sample
      team.save
    end
  end

end
