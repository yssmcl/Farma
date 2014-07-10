class Sequence::ExercisesOrdering
  include Mongoid::Document
  include Mongoid::Timestamps

 field :user_sequence, type: Array , default:[]

 field :statistic_id, type: Moped::BSON::ObjectId


 embedded_in :auto_sequence, class_name: "Sequence::AutoSequence",  inverse_of: :exercises_ordering

 after_create :calculate_vector_of_user_exercises

 STEP_SIZE = 5 


  def statistic 
    @statistic ||= Sequence::Statistic.find(self.statistic_id)
  end


  # This method supposes that every exercise have just one question
  def nextExercise() 
     last_done_question = last_question(auto_sequence.user)
     unless last_done_question.nil?     	 
        last_exerc = Question.find(last_done_question.from_question_id).exercise.id
        ind_last_exerc = index_of(last_exerc)
        user_sequence[ind_last_exerc][2] = true
        if last_done_question.correct?
             # save as correct answer 
             user_sequence[ind_last_exerc][3] = true
             save
          nxt_exerc = next_exercise_minimal_path_not_done
          if nxt_exerc.nil?  # no more exercises
             return last_exerc
                # verify if the last exercise index + step size is before of the next exercise of the minimal path
          elsif ind_last_exerc + STEP_SIZE < index_of(Moped::BSON::ObjectId.from_string(nxt_exerc))
              # goes to first exercise not done after the last solved in minimal path
              return first_not_done_exercise
            else   
              return  nxt_exerc
          end
        else 
          save 
          nro_tentativas = last_attempt_number(auto_sequence.user)
          mediana = question_median(last_done_question.from_question_id)          
        	if  nro_tentativas >= mediana
            min_ind_exerc = last_exercise_minimal_path_correctly_done
            min_index = 0
            if min_ind_exerc.nil? # student failed on every exercises of the minimal path
                # find the last correct exercise before the actual
                min_ind_exerc = last_exercise_correctly_done_before(ind_last_exerc)
                if min_ind_exerc.nil? # no exercise found, then find the last done before the actual
                  min_ind_exerc = last_exercise_done_before(ind_last_exerc)                   
                end
            end
            min_index = index_of(Moped::BSON::ObjectId.from_string(min_ind_exerc))          
            medium_index = (min_index + ind_last_exerc)/2
            return first_not_done_exercise_after_index(medium_index)
        	else  # continues at the same exercise             
        		return last_exerc
        	end             
        end    
     else # returns the first exercise
        return self.user_sequence[0][0]
     end
  end


  private
    # returns the last one question done by the user
     def last_question (user)
       return user.answers.every.desc(:created_at).limit(1).first
     end

    # returns the attempts number of the last one question done by the user
     def last_attempt_number (user)
       t = user.answers.every.desc(:created_at).limit(1).first
       unless t.nil? 
         t.attempt_number
       else nil
       end
     end

     def question_median(question_id)
       questao_modificada = question_id.to_s
       self.statistic.question_statistics[questao_modificada]["median"]

     end
     
     # calculates the vector that marks the exercises done and not done by the user
     def calculate_vector_of_user_exercises
      
        if self.user_sequence.empty? 

          new_order = self.statistic.order_exercises.map do |key, value| 
             [key, value["actual_position"], false, false]
          end
          new_order.sort! { |a,b| a[1] <=> b[1]} # ordena pela actual_position
          self.user_sequence = new_order          
        end
        save
     end

    # returns the index of the exercise id in the vector
     def index_of(exerc_id)
        i = 0
        while((i < self.user_sequence.size()) && (Moped::BSON::ObjectId.from_string(self.user_sequence[i][0]) != exerc_id)) do
          i = i + 1
        end
        if i == self.user_sequence.size() 
           return nil   # not found
        else
           return i
        end
     end

    # returns the last done exercise id by the user of higher difficulty
     def last_done_exercise_of_greater_difficulty
         i = self.user_sequence.size() - 1
          while(!self.user_sequence[i][2]) do
            i = i - 1
          end
          return self.user_sequence[i][0]
     end

     # returns the first not done exercise of lowest difficulty higher than last done exercise in minimal path
     def first_not_done_exercise
         i = 0
         while(i < self.user_sequence.size() && self.user_sequence[i][2])  do
            i = i + STEP_SIZE
         end
         if i < self.user_sequence.size()
            i = i - STEP_SIZE + 1
            while(self.user_sequence[i][2]) do
              i = i + 1
            end
            return self.user_sequence[i][0]
         elsif self.user_sequence.last[2]  # last exercise is done
               return nil
         else
            i = i - STEP_SIZE + 1
            while(self.user_sequence[i][2]) do
              i = i + 1
            end
            return self.user_sequence[i][0]
         end
     end
    
    # returns the first not done exercise after the index
    def first_not_done_exercise_after_index(index)
      i = index
      while(i < self.user_sequence.size() && self.user_sequence[i][2])  do
         i = i + 1
      end
      if(i < self.user_sequence.size())
        return self.user_sequence[i][0]
      else 
        return nil
      end   
    end

    # returns the first exercise id in the minimal path not done yet
     def next_exercise_minimal_path_not_done
         i = 0
         while(i < self.user_sequence.size() && self.user_sequence[i][2]) do
            i = i + STEP_SIZE
         end
         if i < self.user_sequence.size()
            return self.user_sequence[i][0]
         elsif self.user_sequence.last[2]  # last exercise is done
               return nil
         else
               return self.user_sequence.last[0]
         end         
     end

     # returns the last exercise id in the minimal path correctly done
     def last_exercise_minimal_path_correctly_done  
        pos = ((self.user_sequence.size() - 1)/STEP_SIZE)*STEP_SIZE #ultimo multiplo de STEP_SIZE
        if self.user_sequence[self.user_sequence.size() - 1][3]
          return self.user_sequence[self.user_sequence.size() - 1][0] # the last one
        else
           pos = ((self.user_sequence.size() - 1)/STEP_SIZE)*STEP_SIZE
           while pos >= 0 && !self.user_sequence[pos][3] do
              pos = pos - STEP_SIZE
           end
           if pos >= 0
              return self.user_sequence[pos][0]
           else
              return nil
           end
        end
     end

     # returns the last exercise done before the index
     def last_exercise_done_before(index)
        if self.user_sequence[index][2] 
          return self.user_sequence[index][0]
        else
           index -= 1
           while index >= 0 && !self.user_sequence[index][2] do
              index  -= 1
           end
           if index >= 0
              return self.user_sequence[index][0]
           else
              return nil
           end
        end      
     end

      # returns the last exercise done before the index
     def last_exercise_correctly_done_before(index)
        index -= 1
        while index >= 0 && !self.user_sequence[index][3] do
              index  -= 1
        end
        if index >= 0
           return self.user_sequence[index][0]
        else
           return nil
        end
     end

end      