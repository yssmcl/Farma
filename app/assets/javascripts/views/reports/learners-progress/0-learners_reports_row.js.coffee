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
    view = new Carrie.Views.LoLearnerVision(learner: @model, lo_id: @options.lo_id, team_id: @options.team_id)
    $(view.render().el).modal('show')
