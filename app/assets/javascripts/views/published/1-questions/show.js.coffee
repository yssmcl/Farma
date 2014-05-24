class Carrie.Published.Views.Question extends Backbone.Marionette.ItemView
  template: 'published/questions/show'
  tagName: 'article'
  className: 'question'

  initialize: ->
    @loadAnswerView()

  loadAnswerView: ->
    if @model.get('last_answer')
      model = Carrie.Models.AnswerShow.findOrCreate(@model.get('last_answer'))
      model = model || new Carrie.Models.AnswerShow(@model.get('last_answer'))
      @view = new Carrie.Views.Answer model: model
    else
      @view = new Carrie.Views.Answer()

  events:
    'click .answer': 'verify_answer'

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard(
      currentResp: @view.resp()
      variables: @model.get('exp_variables')
      many_answers: @model.get('many_answers')
      eql_sinal: @model.get('eql_sinal')
      callback: (val) =>
        @sendAnswer(val)
    ).render().el
    $(keyboard).modal('show')

  sendAnswer: (resp) ->
    answer = new Carrie.Models.Answer
      question: @model
      response: resp
      team_id: @options.team_id

    answer.save answer.attributes,
      wait: true
      success: (model, response, options) =>
        @view = new Carrie.Views.Answer
          model: Carrie.Models.AnswerShow.findOrCreate(model.attributes)

        @renderAnswerView()
        @renderLastAnswerView(model)
        @addModelToAnswersView(model)
        @updateProgressBar(model);

      error: (model, response, options) ->
        alert resp.responseText

  renderAnswerView: ->
    $(@el).find('.answer-group').html @view.render().el

  renderLastAnswerView: (la) ->
    last_answer =
      tip: la.get('tip')
      correct: la.get('correct')
      response: la.get('response')
      try_number: la.get('try_number')
    @model.set('last_answer', last_answer)

  renderQuestionAnswers: ->
    if @options.team_id # just show for a OA published in a team
      #TODO: remover após o experimento
      if $('body').data('control-group') != true
        @answersView = new Carrie.Published.CompositeViews.QuestionAnswers
          question_id: @model.get('id')
        $(@el).find("#question-#{@model.get('id')}-answers").html @answersView.render().el

  addModelToAnswersView: (model) ->
    if @options.team_id # just add for OA published in a team
      @answersView.addAnswer(model)

  updateProgressBar: (model) ->
    if model.get('completeness')
      progress = $('.progress-success .bar')
      progress.html("#{model.get('completeness')}% Concluído")
      progress.attr('style', "width: #{model.get('completeness')}%")

  onRender: ->
    @renderAnswerView()
    @renderQuestionAnswers()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
