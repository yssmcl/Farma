class Carrie.Collections.WrongCorrectAnswers extends Backbone.Collection
  model: Carrie.Models.WrongCorrectAnswer

  initialize: ->
    Carrie.Utils.Loading @
