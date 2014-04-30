class Carrie.CompositeViews.LearnersReportLoTable extends Backbone.Marionette.CompositeView
  template: 'reports/learner-lo/report_table'
  tagName: 'section'
  itemView: Carrie.CompositeViews.LearnersReportLoRow
  itemViewContainer: 'tbody'
  itemViewOptions: ->
    team_id: @options.team_id
    lo_id: @options.lo_id
    learner_id: @options.learner_id

  initialize: ->
    @url = "/api/reports/teams/#{@options.team_id}/" +
           "los/#{@options.lo_id}/learners/#{@options.learner_id}"
    @collection = new Carrie.Collections.LeanerAnswersByQuestions
    @collection.fetch
      url: @url

  onRender: ->
    @setProgressBar()
    @setLinkToExport()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  setLinkToExport: ->
    console.log $(@el).find('a#export_to_excel')
    $(@el).find('a#export_to_excel').attr('href', "#{@url}.xls")

  setProgressBar: ->
    progress = $('.progress-success .bar')
    progress.html("#{@collection.completeness}% Concluído")
    progress.attr('style', "width: #{@collection.completeness}%")


