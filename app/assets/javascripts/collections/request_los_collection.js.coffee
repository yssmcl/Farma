class Carrie.Collections.RequestLos extends Backbone.Collection
  model: Carrie.Models.RequestLo

  initialize: ->
    Carrie.Utils.Loading @
