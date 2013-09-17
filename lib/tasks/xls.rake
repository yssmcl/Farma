# encoding: utf-8
namespace :xls do
  # ******** to excel *********** #
  class Array
    def to_xls
      content = ''
      self.each do |row|
        row.map! {|col| col = col.to_s.gsub(/(\t|\r\n|\r|\n)/, " ").gsub(/ +/, " ") }
        content << row.join("\t")
        content << "\n"
      end
      content
    end
  end
  # ********* end *************** #

  desc "Create a xls document"
  task :generate => :environment do
    datas = []
    headers = ['Turma', 'Aprendiz', 'Exercício', 'Questão', 'Data de ocorrência', 'Hora de ocorrência', 'Resposta', 'Correta', 'Resposta Correta']
    datas.push headers

    #answers = Answer.every.sort {|a,b| a.user.name <=> b.user.name }
    #answers = answers.select {|a| a.lo.name = 'Pitágoras Mix - Senai - Curitiba/PR' }
    answers = Answer.every.where('lo.name' => 'Pitágoras Max - Senai - Curitiba/PR').asc(:'user.name')
    answers = answers.sort {|a,b| [a.user.name, a.created_at] <=> [b.user.name, b.created_at] }

    answers.each do |answer|
      datas.push [answer.team.name, answer.user.name, answer.exercise.title, answer.question.title,
       I18n.l(answer.created_at, format: :date),
       I18n.l(answer.created_at, format: :only_time),
       answer.response, answer.correct?, answer.question.correct_answer ]
    end

    f = File.new("answers-pitagoras-max-senai.xls", "w+")
    f << datas.to_xls
    f.close
  end
end
