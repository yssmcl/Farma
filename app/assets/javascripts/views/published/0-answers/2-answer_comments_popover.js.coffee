class Carrie.CompositeViews.AnswerComments extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'published/answers/comments'
  itemView: Carrie.Views.AnswerComment
  itemViewContainer: '.comments-list-pop-over'

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
