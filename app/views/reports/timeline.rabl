#encoding: utf-8
object false

child :timeline do
  node(:headline) {"Linha do tempo de #{@user.name} "}
  node(:type) {"default"}
  node(:text) do 
    text =  "<p>Turma: #{@team.name}</p>"
    text += "<p>Objeto de Aprendizagem: #{@lo.name}</p>"
    text += "<p>#{@lo.description}</p>"
    text
  end

  child @answers => :date do
    node(:startDate) {|a| a.created_at}
    node(:endDate) {|a| a.created_at}
    node(:headline) {|a| "#{a.question.exercise.title} - #{a.question.title}" }
    node(:text)  do  |a|
      @answer = a
      template = Rails.root.to_s + '/app/views/reports/_question.erb'
      ERB.new(File.read(template)).result(self.binding)
    end
    node(:class) {|a| "date-answer"}
  end

  child @answers => :era do
    node(:startDate) {|a| a.created_at}
    node(:endDate) {|a| a.created_at}
    node(:headline) {|a| a.question.title }
    node(:text) {|a| a.question.content}
    node(:class) {|a| "era-answer-#{a.id}"}
  end
end
