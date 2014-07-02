namespace :sequence do

  desc "Generate a copy of a LO with new sequencing"
  task :generate_new_lo => :environment do
    lo_id = "51a018ab759b7491ef00003d"   # OA Pitágoras Max - Senai - Curitiba/PR
    team_id = "51b9eef3759b74dcc20000c5" # Turma Pitágoras Max - Senai

    lo = Lo.find(lo_id)
    to_user = lo.user

    ## Clone Lo
    lo_cloned = DeepCloneLo.clone(lo, to_user)
    
    ## Calculates Statistic
    statistic = Sequence::Statistic.find_or_create_by(lo_id: lo_id,
                                                      team_id: team_id)
    #statistic.calculate_statistics

    new_order = statistic.order_exercises.map do |key, value| 
      [key, value["actual_position"]]
    end
    new_order.sort! { |a,b| a[1] <=> b[1]} # ordena pela actual_position

    new_order.map! do |a|
      exer = Exercise.find(a[0])
      or_index = lo.page_of(exer)
      lc = lo_cloned.content_at(or_index)
      lc.id.to_s
    end

    # Update Lo
    # contents retorna as introduções e exercícios na ordem definada pelo professor
    group = {}
    introductions = []
    lo_cloned.contents.each_with_index do |content, index|
      if content.is_a?(Introduction)
        introductions << content.id
      else
        group[content.id.to_s] = introductions
        introductions = []
      end
    end

    # atualiza posição
    position = 0
    new_order.each do |exer_id|
      group[exer_id].each_with_index do |intro_id|
        intro = Introduction.find(intro_id)
        intro.update_attribute(:position, position)
        position += 1
      end
      exer = Exercise.find(exer_id)
      exer.update_attribute(:position, position)
      position += 1
    end
  end

  desc "Copy LO Logartimos to new Lo "
  task :transform_lo => :environment do
    lo_id = "5375156f759b741405000002"   # OA Logaritmos 
    team_id = "53187690759b7401c3000435" # 2NAT2 - Matemática

    lo = Lo.find(lo_id)
    user = lo.user

    # Copy Lo
    name = "#{lo.name} - #{I18n.l Time.now}"
    clone = user.los.build name: name, description: lo.description,
      available: true
    clone.copy_from= lo
    clone.save!

    # Add Lo to Team
    team = Team.find(team_id)
    team.lo_ids << clone.id
    team.save

    # Copy Introductions
    lo.introductions.each do |intro|
      intro_clone = clone.introductions.create! title: intro.title,
                                                content: intro.content,
                                                available: intro.available
    end

    # Transform each question in a exercise
    lo.exercises.each do |exercise|
      exercise.questions.each do |question|
        exercise_clone = clone.exercises.create! title: exercise.title,
          content: exercise.content,
          available: exercise.available

        question_clone = exercise_clone.questions.create! title: question.title,
          content: question.content, available: question.available,
          correct_answer: question.correct_answer,
          many_answers: question.many_answers,
          exp_variables: question.exp_variables,
          eql_sinal: question.eql_sinal,
          cmas_order: question.cmas_order,
          precision: question.precision

        question.tips.each do |tip|
          question_clone.tips.create! number_of_tries: tip.number_of_tries, content: tip.content
        end

        # Copy answers
        answers = Answers::Soluction.where(from_question_id: question.id, team_id: team.id)
        answers.each do |answer|
          user = answer.user
          params = {response: answer.response,
                    from_question_id: question_clone.id,
                    team_id: answer.team_id}

          user.answers.create(params)
        end
      end
    end
  end

  desc "change database"
  task :change_db => :environment do
    lo_id = "53b216f4454cd9f373000001"   # OA Logaritmos 
    team_id = "53187690759b7401c3000435" # 2NAT2 - Matemática

    # "$2a$10$LjAS8.E7NTCdET01Eli1GepJhK.2LmTPn.XzdZHb8n.S4BfcwsGuK"
    # carlaborille@gmail.com senha: ceepufpr
    user = User.where(email: 'carlaborille@gmail.com').first
    user_db = User.with(session: :writeable).new(email: user.email,
                                                 password: "123456",
                                                 password_confirmation: "123456",
                                                 sign_in_count: user.sign_in_count,
                                                 name: user.name,
                                                 gravatar: user.gravatar,
                                                 admin: user.admin)
    user_db.save!
    user_db.with(session: :writeable).update_attribute(:encrypted_password, user.encrypted_password)

    team = Team.find(team_id)
    team_db = Team.with(session: :writeable).create!(code: team.code,
                                    name: team.name,
                                    available: team.available,
                                    owner_id: user_db.id)

    users = team.users + User.where(email: 'farma.ufpr@gmail.com')
    users.each do |u|
      user_enroll = User.with(session: :writeable).new(email: u.email,
                                                   password: "123456",
                                                   password_confirmation: "123456",
                                                   sign_in_count: u.sign_in_count,
                                                   name: u.name,
                                                   gravatar: u.gravatar,
                                                   admin: u.admin)
      user_enroll.save!
      user_enroll.team_ids << team_db.with(session: :writeable).id
      user_enroll.with(session: :writeable).update_attribute(:encrypted_password, u.encrypted_password)
    end

    # Copy Lo
    lo = Lo.find(lo_id)
    lo_db = Lo.with(session: :writeable).create!(name: lo.name,
                                                 description: lo.description,
                                                 available: true)
    lo_db.with(session: :writeable).update_attribute(:user_id, user_db.id)
    id = team_db.with(session: :writeable).id
    lo_db.with(session: :writeable).update_attribute(:team_ids, [id])
    #lo_db.with(session: :writeable).team_ids << team_db.with(session: :writeable).id

    # Copy Introductions
    lo.introductions.each do |intro|
       intro_db = Introduction.with(session: :writeable).create!(title: intro.title,
                                                      content: intro.content,
                                                      available: intro.available)
                                                      
       intro_db.with(session: :writeable).update_attribute(:lo_id, lo_db.id)
    end

     lo.exercises.each do |exercise|
        exercise_db = Exercise.with(session: :writeable).create!(title: exercise.title,
                                                                    content: exercise.content,
                                                                    available: exercise.available)
        exercise_db.with(session: :writeable).update_attribute(:lo_id, lo_db.id)

        exercise.questions.each do |question|

          question_db = Question.with(session: :writeable).create! title: question.title,
            content: question.content, available: question.available,
            correct_answer: question.correct_answer,
            many_answers: question.many_answers,
            exp_variables: question.exp_variables,
            eql_sinal: question.eql_sinal,
            cmas_order: question.cmas_order,
            precision: question.precision

            question_db.with(session: :writeable).update_attribute(:exercise_id, exercise_db.id)

            question.tips.each do |tip|
              tip_db = Tip.with(session: :writeable).create! number_of_tries: tip.number_of_tries,
                                                             content: tip.content
              tip_db.with(session: :writeable).update_attribute(:question_id, question_db.id)
            end

            # Copy answers verificar last answer
            answers = Answers::Soluction.where(from_question_id: question.id, team_id: team.id)
            answers.each do |answer|
              user_email = answer.user.email
              Mongoid.override_database("farma_development_auto_sequence_only")
              usr = User.where(email: user_email).first

              params = {response: answer.response,
                        from_question_id: question_db.id,
                        team_id: team_db.id}

              usr.answers.create!(params)
              Mongoid.override_database(nil)
            end
        end
     end
  end
end
