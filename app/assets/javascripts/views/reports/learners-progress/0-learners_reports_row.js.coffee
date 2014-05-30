class Carrie.CompositeViews.LearnersReportRow extends Backbone.Marionette.ItemView
  template: 'reports/learner-progress/learners_report_row'
  tagName: 'tr'

  events: 
    'click .timeline-link': 'timeline'
    'click .learner-vision-link': 'learnerVision'

  timeline: (ev) ->
    ev.preventDefault()
    url = "/reports/teams/#{@options.team_id}/los/#{@options.lo_id}/timeline/#{@model.get('id')}"
    Backbone.history.navigate url, true

  learnerVision: (ev) ->
    ev.preventDefault()
    @fetchLo()
   
  fetchLo: ->
    lo_id = @options.lo_id
    @lo = Carrie.Published.Models.Lo.findOrCreate(lo_id)
    Carrie.Utils.clearBackboneRelationalCache() if @lo
    @lo = new Carrie.Published.Models.Lo(id: lo_id)

    @lo.fetch
      data:
        learner_id: @model.get('id')
        team_id: @options.team_id
      success: =>
        @lo.set('learner', {name: @model.get('name')})
        view = new Carrie.Views.LoLearnerVision(model: @lo, learner: @model, lo_id: @options.lo_id, team_id: @options.team_id)
        $(view.render().el).modal('show')
      error: =>
        alert('Objeto de aprendizagem não encontrado!')
        url = "my-learners-progress/teams/#{@options.team_id}/los/#{@options.lo_id}"
        Backbone.history.navigate(url, true)
