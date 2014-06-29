#encoding: utf-8
module DeepCloneLo

  def self.clone(lo, to_user)
    clone = Clone.new(lo, to_user)
    clone.run
  end

  class Clone
    def initialize(lo, user)
      @lo = lo
      @user = user
    end

    def run
      name = "#{@lo.name} - Cópia de #{@lo.user.name} em #{I18n.l Time.now}"
      @clone = @user.los.build name: name, description: @lo.description,
                                  available: true
      @clone.copy_from= @lo
      @clone.save!

      clone_introductions
      return @clone
    end

    private
    def clone_introductions
      @lo.introductions.each do |intro|
        intro_clone = @clone.introductions.create! title: intro.title, content: intro.content,
                                                   available: intro.available

        intro_clone.update_attribute(:position, intro.position)
      end

      clone_exercises
    end

    def clone_exercises
     @lo.exercises.each do |exercise|
        exercise_clone = @clone.exercises.create! title: exercise.title,
                            content: exercise.content, available: exercise.available
        
        exercise_clone.update_attribute(:position, exercise.position)

        clone_questions(exercise, exercise_clone)
      end
    end

    def clone_questions(exercise, exercise_clone)
      exercise.questions.each do |question|
        question_clone = exercise_clone.questions.create! title: question.title,
                            content: question.content, available: question.available,
                            correct_answer: question.correct_answer,
                            many_answers: question.many_answers,
                            exp_variables: question.exp_variables,
                            eql_sinal: question.eql_sinal,
                            cmas_order: question.cmas_order,
                            precision: question.precision

        question_clone.update_attribute(:position, question.position)
        clone_tips(question, question_clone)
      end
    end

    def clone_tips(question, question_clone)
      question.tips.each do |tip|
        question_clone.tips.create! number_of_tries: tip.number_of_tries, content: tip.content
      end
    end
  end

end
