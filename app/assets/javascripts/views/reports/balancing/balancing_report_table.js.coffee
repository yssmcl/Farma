class Carrie.CompositeViews.BalancingReportTable extends Backbone.Marionette.CompositeView
  template: 'reports/balancing/balancing_report_table'
  tagName: 'section'
  itemView: Carrie.CompositeViews.BalancingReportRow
  itemViewContainer: 'tbody'
  itemViewOptions: ->
    team_id: @options.team_id
    lo_id: @options.lo_id

  initialize: ->
    @collection = new Carrie.Collections.Statistics
    @collection.fetch
      url: "/api/reports/balancing/teams/#{@options.team_id}/los/#{@options.lo_id}"
