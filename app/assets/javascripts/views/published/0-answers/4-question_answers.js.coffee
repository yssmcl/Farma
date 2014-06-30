class Carrie.Published.CompositeViews.QuestionAnswers extends Backbone.Marionette.CompositeView
  template: 'published/answers/index'
  className: 'question-answers'
  itemView: Carrie.Published.Views.QuestionAnswer
  itemViewContainer: 'tbody'
  itemViewOptions: ->
    parentModel: @

  initialize: ->
    @collection = new Carrie.Collections.WrongCorrectAnswers []
    @url = "/api/answers/for-question/#{@options.question_id}"
    if @options.learner_id
      @url += "?learner_id=#{@options.learner_id}"

    @collection.fetch
      url: @url
      success: =>
        $(@el).find(".amount").html(@collection.length)

  addAnswer: (model) ->
    answer = Carrie.Models.WrongCorrectAnswer.findOrCreate(model.get('id'))
    unless answer
      answer = new Carrie.Models.WrongCorrectAnswer
        id: model.get('id')
        response: model.get('response')
        correct: model.get('correct')
        attempt_number: model.get('attempt_number')
        created_at:  model.get('created_at')
        comments_size: 0

      @collection.add answer, at: 0

  collectionEvents:
    'add': 'refresh'

  refresh: ->
    $(@el).find(".amount").html(@collection.length)
    el = @el
    setTimeout ( ->
        MathJax.Hub.Queue(["Typeset",MathJax.Hub, el])
    ), 100

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
    $(@el).find('th[data-toggle="tooltip"]').tooltip()

  # Insert in the correct position
  # This allow use at: 0 on add method
  appendHtml: (collectionView, itemView, index) ->
    # could just quickly
    # use prepend
    if (index == 0)
      return collectionView.$el.find(collectionView.itemViewContainer).prepend(itemView.el)
    else
      # see if there is already
      # a child at the index
      childAtIndex = collectionView.$el.find(collectionView.itemViewContainer).children().eq(index)
      if (childAtIndex.length)
        return childAtIndex.find(collectionView.itemViewContainer).before(itemView.el)
      else
        return collectionView.$el.find(collectionView.itemViewContainer).append(itemView.el)
