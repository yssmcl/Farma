class Carrie.Views.LearnerReportTimeline extends Backbone.Marionette.ItemView
  template: 'reports/learner_report_timeline'
  tagName: 'section'

  events: 
    'click .btn-retroaction' : 'retroaction'

  initialize: ->
    @loadData()

  onRender: ->
    $(@el).find('#timeline').delegate ".nav-next", "click", =>
       MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
    $(@el).find('#timeline').delegate ".flag-content", "click", =>
       MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  loadData: ->
    $.ajax
      url: @options.url
      dataType: 'json'
      success: (data) =>
        @createTimeline(data)

  createTimeline: (data) ->
    if data.timeline.date.length > 0
      createStoryJS
        type: 'timeline'
        width: '100%'
        height: '600'
        source: data
        embed_id: 'timeline'
    else
      alert('Não existe respostas para esse aprendiz')
      console.log @options.url
      Backbone.history.navigate(@options.backUrl, true)

  retroaction: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data('answer-id')
    Carrie.Helpers.Retroaction.open(id)
