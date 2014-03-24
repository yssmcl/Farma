class Carrie.Models.Answer extends Backbone.RelationalModel
  urlRoot: ->
    '/api/answers'

  paramRoot: 'answer'

  # because the answer is used for authoring and published
  #initialize: ->
  #  @fixed_key = if @get('question').get('exercise') then '' else '_p'

  default:
    tip: ''

  toJSON: ->
    response: @get('response')
    #lo_id: @get('question').get("exercise#{@fixed_key}").get("lo#{@fixed_key}").get('id')
    #exercise_id: @get('question').get("exercise#{@fixed_key}").get('id')
    question_id: @get('question').get('id')
    tip: @get('tip')
    tips: @get('tips')
    to_test: @get('to_test')
    team_id: @get('team_id')
