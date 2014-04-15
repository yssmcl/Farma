class Carrie.CompositeViews.LearnersReportRow extends Backbone.Marionette.ItemView
  template: 'reports/learners_report_row'
  tagName: 'tr'

  events: 
    'click .timeline-link': 'timeline'

  timeline: (ev) ->
    ev.preventDefault()
    url = "/reports/teams/#{@options.team_id}/los/#{@options.lo_id}/timeline/#{@model.get('id')}"
    Backbone.history.navigate url, true

