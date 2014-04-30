class Carrie.Collections.LeanerAnswersByQuestions extends Backbone.Collection
  model: Carrie.Models.LoForReport

  parse: (resp, xhr) ->
    @completeness = resp.completeness
    return resp.questions_answer
