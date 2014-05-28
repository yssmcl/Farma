class Sequence::Statistic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :difficulty_degree, type: Hash
  field :question_statistics, type: Hash
  field :order_exercises, type: Hash
  field :rating_user, type: Hash

  field :team_id, type: Moped::BSON::ObjectId

  def calculate_statistics
    team = Team.find(team_id)
    users = team.users
    total_users = users.count
    puts "total de alunos: #{total_users}"
    lo = Lo.find(lo_id)
    self.question_statistics = Hash.new 

    difficulty_degree_exercise = Hash.new 
    self.order_exercises = Hash.new

    puts "numero de exercicios: #{lo.exercises.count}"

    # Os exercícios são retornados na ordem correta
    # lo.exercises.each_with_index do |exercise, index|
    lo.exercises.each do |exercise|

      difficulty_degree_vector = []

      exercise.questions.each do |question| 

        attempts = []
        self.question_statistics[question.id] = Hash.new 
        self.question_statistics[question.id][:number_of_correct_response] = 0
        self.question_statistics[question.id][:number_of_wrong_response] = 0
        users.each do |user|

          answer = user.answers.every.where(from_question_id: question.id).desc(:created_at).limit(1).first
          if answer
            attempts << answer.attempt_number
          end
          ans_correct = user.answers.corrects.where(from_question_id: question.id)              
          unless ans_correct.empty?
            self.question_statistics[question.id][:number_of_correct_response] += 1
          end
        end
        self.question_statistics[question.id][:number_of_wrong_response] = total_users - self.question_statistics[question.id][:number_of_correct_response]
        if self.question_statistics[question.id][:number_of_wrong_response] == 0
          self.question_statistics[question.id][:number_of_wrong_response] = 1     
        end
        self.question_statistics[question.id][:difficulty_degree] = 10*self.question_statistics[question.id][:number_of_wrong_response] / (self.question_statistics[question.id][:number_of_wrong_response] + self.question_statistics[question.id][:number_of_correct_response])
        difficulty_degree_vector << self.question_statistics[question.id][:difficulty_degree]
        if attempts == []
          self.question_statistics[question.id][:median] = 1
        else
          self.question_statistics[question.id][:median] = calculate_median(attempts)
        end
      end

      # Se o exercício possui questões
      # TODO: Verificar
      unless exercise.questions.empty?
        difficulty_degree_exercise[exercise.id] =  difficulty_degree_vector.inject(0.0) { |sum, el| sum + el } / difficulty_degree_vector.size           
        puts "Exercicio: #{exercise.id} - Dificuldade: #{difficulty_degree_exercise[exercise.id]}"
      end
    end
    exercises_ordered = difficulty_degree_exercise.keys.sort_by do |a|
      difficulty_degree_exercise[a]
    end
    puts "exercicios ordenados: #{exercises_ordered}"
    i = 0
    exercises_ordered.each do |ex|
      self.order_exercises[ex] = Hash.new
      #puts "xxxxx ---#{lo.exercises.where(exercise_id: ex)[:position]}"
      #position = lo.pages.index { |c| c.id == exercise_id}
      self.order_exercises[ex][:previous_position] = 1
      self.order_exercises[ex][:actual_position] = i
      i = i + 1
    end
    puts self.order_exercises
    self.question_statistics.each {|key,value| puts "#{Question.find(key).title} = #{value}"}
    self.calculate_rating
    save
  end

  #  Median of a vector
  def calculate_median (vetor)
    sorted = vetor.sort
    mid = (sorted.length - 1) / 2.0
    (sorted[mid.floor] + sorted[mid.ceil]) / 2.0
  end

  def calculate_rating ()
    team = Team.find(team_id)
    users = team.users
    total_users = users.count
    puts "total de alunos: #{total_users}"
    self.rating_user = Hash.new
    lo = Lo.find(lo_id)
    lo.exercises.each do |exercise|
      exercise.questions.each do |question|    
        users.each do |user|
          user_attempts = 0
          answer = user.answers.where(from_question_id: question.id).desc(:created_at).limit(1).first
          if answer.nil? 
            user_attempts = 0
          else
            user_attempts = answer.attempt_number
          end
          if user_attempts >= 10
            user_attempts = 10
          end
          a = 0
          e = 0
          ans_correct = user.answers.corrects.where(from_question_id: question.id)              
          if ans_correct.empty?
            a = 0
            e = 1
          else
            a = 1
            e = 0
          end
          previous_rating = 5.5
          if self.rating_user[user.id]
            previous_rating = self.rating_user[user.id]
          end
          k1 = 1 - (previous_rating/10.0)
          k2 = (previous_rating - 1)/10.0
          alfa =(1.0/self.question_statistics[question.id][:number_of_correct_response])
          beta =(1.0/self.question_statistics[question.id][:number_of_wrong_response])
          if self.question_statistics[question.id][:median] == 0
            mediana = 1
          else
            mediana = self.question_statistics[question.id][:median]
          end
          if user_attempts > mediana
            user_attempts = mediana
          end
          actual_rating = previous_rating + a*k1*alfa*(10 - 9*(user_attempts/mediana)) - e*k2*beta*10*(user_attempts/mediana)
          self.rating_user[user.id] = actual_rating
        end  
      end
    end    
    puts "rating:#{self.rating_user}"
  end


  def calculate_statistics_aggregation
    team = Team.find(team_id)
    users = team.users
    total_users = users.count
    puts "total de alunos: #{total_users}"
    lo = Lo.find(lo_id)
    self.question_statistics = Hash.new 
    lo.exercises.each do |exercise|
      exercise.questions.each do |question|

        attempts = []
        self.question_statistics[question.id] = Hash.new 
        self.question_statistics[question.id][:number_of_correct_response] = 0
        self.question_statistics[question.id][:number_of_wrong_response] = 0

        pipeline =  [ { "$match" => { "from_question_id" => question.id,
                                      "to_test" => false, 
                                      "team_id" => {"$ne" => nil},
                                      "correct" => true }},
                                      { "$group" => {'_id' => '$user_id',
                                                     'attempts_number' => {'$max' => '$attempt_number'}}}
        ]
        Answers::Soluction.collection.distinct()
        #res = Answers::Soluction.collection.aggregate(pipeline)
        Answers::Soluction.collection.aggregate(pipeline)

        users.each do |user|
          answer = user.answers.where(from_question_id: question.id).desc(:created_at).limit(1).first
          if answer
            attempts << answer.attempt_number
          end
          ans_correct = user.answers.corrects.where(from_question_id: question.id)
          if ans_correct
            self.question_statistics[question.id][:number_of_correct_response] += 1
          end
        end
        self.question_statistics[question.id][:number_of_wrong_response] = total_users - self.question_statistics[question.id][:number_of_correct_response]
        if self.question_statistics[question.id][:number_of_wrong_response] == 0
          self.question_statistics[question.id][:number_of_wrong_response] = 1
        end
        self.question_statistics[question.id][:difficulty_degree] = 10*self.question_statistics[question.id][:number_of_wrong_response] / (self.question_statistics[question.id][:number_of_wrong_response] + self.question_statistics[question.id][:number_of_correct_response])
        if attempts == []
          self.question_statistics[question.id][:median] = 1
        else
          self.question_statistics[question.id][:median] = calculate_median(attempts)
        end
      end
    end
    self.question_statistics.each {|key,value| puts "#{key} = #{value}"}
    self.calculate_rating
    #  team = Team.find :team_id
    #  team.users.each do |user|
    #   user.answers.where("lo.from_id" => lo_id, :team_id => team_id)
    #  end
  end


end
