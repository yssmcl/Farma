class Carrie.CompositeViews.LearnersReportTable extends Backbone.Marionette.CompositeView
  template: 'reports/learner-progress/learners_report_table'
  tagName: 'section'
  itemView: Carrie.CompositeViews.LearnersReportRow
  itemViewContainer: 'tbody'
  itemViewOptions: ->
    team_id: @options.team_id
    lo_id: @options.lo_id

  initialize: ->
    @collection = new Carrie.Collections.Learners
    @collection.fetch
      url: "/api/reports/progress/teams/#{@options.team_id}/los/#{@options.lo_id}"
