xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet", 
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",    
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:spreadsheet" 
  }) do

  xml.Worksheet 'ss:Name' => @learner.name do
    xml.Table do
      xml.Row
      xml.Row do
        xml.Cell { xml.Data 'Turma', 'ss:Type' => 'String' }
        xml.Cell { xml.Data @team.name, 'ss:Type' => 'String' }
      end
      xml.Row do
        xml.Cell { xml.Data 'Objeto de Aprendizagem', 'ss:Type' => 'String' }
        xml.Cell { xml.Data @lo.name, 'ss:Type' => 'String' }
      end
      xml.Row do
        xml.Cell { xml.Data 'Aprendiz', 'ss:Type' => 'String' }
        xml.Cell { xml.Data @learner.name, 'ss:Type' => 'String' }
      end
      xml.Row do
        xml.Cell { xml.Data 'Porcentagem Concluída', 'ss:Type' => 'String' }
        xml.Cell { xml.Data @learner.completeness_of(@team, @lo), 'ss:Type' => 'String' }
      end

      xml.Row

      xml.Row do
        xml.Cell { xml.Data 'Exercício', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Questão', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Resposta', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Correta?', 'ss:Type' => 'String' }
        xml.Cell { xml.Data 'Nº de Tentativas', 'ss:Type' => 'String' }
      end

      # Rows
      @lo.exercises_avaiable.each do |exercise|
        exercise.questions_available.each do |question|
          xml.Row do
            # primeira resposta correta
            answer = @learner.answers.where(from_question_id: question.id,
                                            correct: true).asc(:created_at).
                                            limit(1).first

            if answer.nil?
              # última resposta
              answer = @learner.answers.where(from_question_id: question.id).
                                        asc(:created_at).limit(1).last
            end

            xml.Cell { xml.Data exercise.title, 'ss:Type' => 'String' }
            xml.Cell { xml.Data question.title, 'ss:Type' => 'String' }

            if answer.nil?
              response = 'Não respondido'
              correct = 'Não respondido'
              attempt_number = 'Não respondido'
            else
              response = answer.response
              correct = answer.correct ? 'Sim' : 'Não'
              attempt_number = answer.attempt_number
            end

            xml.Cell { xml.Data response, 'ss:Type' => 'String' }
            xml.Cell { xml.Data correct, 'ss:Type' => 'String' }
            xml.Cell { xml.Data attempt_number, 'ss:Type' => 'String' }
          end
        end
      end
    end
  end
end
