class Carrie.Published.Views.Exercise extends Backbone.Marionette.CompositeView
  template: 'published/exercises/show'
  tagName: 'article'
  itemView: Carrie.Published.Views.Question

  # Removed on 07/05/2014
  # Because its no long allowed a user clear your answers
  #events:
  #  'click a.reset-exercise' : 'clearLastAnswers'

  itemViewOptions: ->
    team_id: @options.team_id

  initialize: ->
    @collection = @model.get('questions')
    this

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
    if @options.retroaction_id
      Carrie.Helpers.Retroaction.open @options.retroaction_id

  # Removed on 07/05/2014
  # Because its no long allowed a user clear your answers  
  # clearLastAnswers: (ev) ->
  #  ev.preventDefault()
  #  obj = new Carrie.Published.Models.ExerciseLastAnswersDelete
  #    lo_id: @model.get('lo_p').get('id')
  #    id: @model.get('id')

  #  obj.destroy
  #    success: =>
  #       _(@collection.models).each (question) ->
  #         question.unset('last_answer')
  #       @render()
