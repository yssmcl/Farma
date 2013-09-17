class Carrie.Collections.Exercises extends Backbone.Collection
  model: Carrie.Models.Exercise
  url: ->
    "/api/los/#{@lo.get('id')}/exercises"
