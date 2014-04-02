class Carrie.Models.LoContent extends Backbone.Model
  urlRoot: ->
    "/api/los/#{@get('lo').id}/#{@contentOf()}"

  contentOf: ->
    if @get('instance') == "Introduction"
      return "introductions"
    else
      return "exercises"
