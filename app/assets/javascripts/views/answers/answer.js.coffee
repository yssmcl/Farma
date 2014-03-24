# Answer for construct a exercise
# TODO: Refatorar!!
class Carrie.Views.Answer extends Backbone.Marionette.ItemView
  template: null
  tagName: 'div'

  events:
    'click a.previous' : 'previousTip'
    'click a.next' : 'nextTip'

  initialize: ->
    if @model
      @tips = @model.get('tips')
      @current_tip_index = 0

      if not @model.get('correct')
        @model.set('classname', 'wrong')
        @model.set('title', 'Incorreto')
        @model.set('tip', @tips[0])
      else
        @model.set('classname', 'right')
        @model.set('title', 'Correto')

      @template = 'answers/answer'
    else
      @template = 'answers/answer_empty'

  resp: ->
    if @model
     return @model.get('response')
    else
      return ""

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  previousTip: (ev) ->
    ev.preventDefault()
    if @tips && @current_tip_index < @tips.length-1
      @current_tip_index++
      $(@el).find('.content .tip-number').html("Dica: " + @tips[@current_tip_index].number_of_tries)
      $(@el).find('.content .tip').html(@tips[@current_tip_index].content)
      MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  nextTip: (ev) ->
    ev.preventDefault()
    if @current_tip_index > 0
      @current_tip_index--
      $(@el).find('.content .tip-number').html("Dica: " + @tips[@current_tip_index].number_of_tries)
      $(@el).find('.content .tip').html(@tips[@current_tip_index].content)
      MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
