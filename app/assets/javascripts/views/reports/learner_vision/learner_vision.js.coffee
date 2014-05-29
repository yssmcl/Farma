class Carrie.Views.LoLearnerVision extends Backbone.Marionette.ItemView
  template: 'reports/learner_vision/lo'
  tagName: 'section'

  initialize: ->
    @getLo()

  getLo: ->
    lo_id = @options.lo_id
    @lo = Carrie.Published.Models.Lo.findOrCreate(lo_id)
    @lo = new Carrie.Published.Models.Lo(id: lo_id) if not @lo

    @lo.fetch
      data:
        learner_id: @options.learner.get('id')
        team_id: @options.team_id
      async: false
      success: (model, response, options) =>
        @loadPaginator()
        #console.log model
      error: (model, response, options) =>
        alert('Objeto de aprendizagem não encontrado!')
        url = "my-learners-progress/teams/#{@options.team_id}/los/#{@options.lo_id}"
        #Backbone.history.navigate(url, true)

    @model = @lo
    @model.set('learner', {name: @options.learner.get('name')})

  loadPaginator: ->
    @paginator = new Carrie.Views.LoLearnerVisionPaginator
      model: @lo
      parentView: @
      page: 0
      learner_id: @options.learner.get('id')

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('.navigator').html(@paginator.render().el)
