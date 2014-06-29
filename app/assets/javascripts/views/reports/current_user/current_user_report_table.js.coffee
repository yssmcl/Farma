class Carrie.CompositeViews.CurrentUserReportTable extends Backbone.Marionette.CompositeView
  template: 'reports/current_user/current_user_report_table'
  tagName: 'section'
  itemView: Carrie.CompositeViews.CurrentUserReportRow
  itemViewContainer: 'tbody'
  #itemViewOptions: ->
  #  team_id: @options.team_id
  #  lo_id: @options.lo_id

  #initialize: ->
  #  @collection = new Carrie.Collections.Learners
  #  @collection.fetch
  #    url: "/api/reports/teams/#{@options.team_id}/los/#{@options.lo_id}"
