class Carrie.Views.LoLearnerVision extends Backbone.Marionette.ItemView
  template: 'reports/learner_vision/lo'
  tagName: 'section'

  initialize: ->
    @loadPaginator()

  loadPaginator: ->
    @paginator = new Carrie.Views.LoLearnerVisionPaginator
      model: @model
      parentView: @
      page: 0
      learner_id: @options.learner.get('id')

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('.navigator').html(@paginator.render().el)
