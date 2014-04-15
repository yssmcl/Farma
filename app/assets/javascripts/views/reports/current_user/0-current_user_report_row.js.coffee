class Carrie.CompositeViews.CurrentUserReportRow extends Backbone.Marionette.ItemView
  template: 'reports/current_user/current_user_report_row'
  tagName: 'tr'

  events: 
    'click .timeline-link': 'timeline'

  timeline: (ev) ->
    ev.preventDefault()
    console.log @model
    url = "/reports/my-timeline/teams/#{@model.get('team').id}/los/#{@model.get('id')}"
    Backbone.history.navigate url, true


