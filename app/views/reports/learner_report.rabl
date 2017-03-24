#encoding: utf-8
object false

node(:completeness) { @learner.completeness_of(@team, @lo) }

node :questions_answer do
  result = []
  @lo.exercises_avaiable.each do |exercise|
    exercise.questions_available.each do |question|
      # primeira resposta correta
      answer = @learner.answers.where(from_question_id: question.id,
                                      correct: true).asc(:created_at).limit(1).first

      if answer.nil?
        # última resposta
        answer = @learner.answers.where(from_question_id: question.id).
                                  asc(:created_at).limit(1).last
      end
      if !answer.nil?
        result << {
            name: @learner.name,
            exercise: exercise.title,
            question: question.title,
            response: (answer.nil? ? 'Não respondido' : "$#{answer.response}$"),
            correct: (answer.nil? ? 'Não respondido' : (answer.correct ? 'Sim' : 'Não')),
            attempt_number: (answer.nil? ? 'Não respondido' : answer.attempt_number),
        }
      end
    end
  end
  result
end
