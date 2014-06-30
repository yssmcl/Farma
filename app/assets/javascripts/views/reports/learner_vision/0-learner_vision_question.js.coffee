class Carrie.Views.LearnerVisionQuestion extends Backbone.Marionette.ItemView
  template: 'published/questions/show'
  tagName: 'article'
  className: 'question'

  loadAnswerView: ->
    if @model.get('last_answer')
      # TODO: Refactoring
      model = Carrie.Models.AnswerShow.findOrCreate({id: @model.get('last_answer')})
      model = model || new Carrie.Models.AnswerShow()
      model.set(@model.get('last_answer'))
      #model = new Carrie.Models.AnswerShow(@model.get('last_answer'))
      @view = new Carrie.Views.Answer model: model
    else
      @view = new Carrie.Views.Answer()


  renderAnswerView: ->
    @loadAnswerView()
    $(@el).find('.answer-group').html @view.render().el

  renderQuestionAnswers: ->
    @answersView = new Carrie.Published.CompositeViews.QuestionAnswers question_id: @model.get('id'), learner_id: @options.learner_id
    $(@el).find("#question-#{@model.get('id')}-answers").html @answersView.render().el

  onRender: ->
    @renderAnswerView()
    @renderQuestionAnswers()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
