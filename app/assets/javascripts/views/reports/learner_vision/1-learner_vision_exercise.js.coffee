class Carrie.Views.LearnerVisionExercise extends Backbone.Marionette.CompositeView
  template: 'published/exercises/show'
  tagName: 'article'
  itemView: Carrie.Views.LearnerVisionQuestion

  itemViewOptions: ->
    team_id: @options.team_id
    learner_id: @options.learner_id

  initialize: ->
    @collection = @model.get('questions')
    this
