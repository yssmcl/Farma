class Carrie.Collections.LoContents extends Backbone.Collection
  model: Carrie.Models.LoContent

  parse: (resp, xhr) ->
    @lo = resp.lo
    return resp.contents
