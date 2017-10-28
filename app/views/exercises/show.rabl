glue @exercise do
  attributes :id, :title, :subtopic, :content, :available, :introduction_ids
  node(:created_at) { |exer| l exer.created_at }
  node(:updated_at) { |exer| l exer.updated_at }

  child(:questions) do
    attributes :id, :title, :content, :available, :correct_answer, :exp_variables,
               :many_answers, :eql_sinal, :cmas_order, :precision

    child(:tips) do
      attributes :id, :content, :number_of_tries
    end
  end

  # child(:introductions) do
  #   attributes :id, :title
  # end
end
