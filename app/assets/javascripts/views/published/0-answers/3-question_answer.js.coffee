class Carrie.Published.Views.QuestionAnswer extends Backbone.Marionette.ItemView
  template: 'published/answers/index_item'
  tagName: 'tr'

  events:
    'click' : 'retro'

  initialize: ->
    @loadPopover()

  loadPopover: ->
    comments = new Backbone.Collection(@model.get('comments'))
    comments_view = new Carrie.CompositeViews.AnswerComments(collection: comments)
    comments_in_html = comments_view.render().el

    options =
      html : true
      trigger: 'manual'
      content: ->
        comments_in_html
      title: ->
        "#{comments.length} comentários recebidos"
      placement: 'right'
      delay: {show: 50, hide: 400}

    $(@el).popover(options).mouseenter( ->
      popover = $(@)
      popover.popover('show')
      setTimeout( ->
        $(".popover").mouseleave ->
          popover.popover('hide')
      , options.delay.show )
    ).mouseleave( ->
      unless $('.popover:hover').length
        $(@).popover('hide')
    )

  retro: (ev) ->
    Carrie.Helpers.Retroaction.open @model.get('id'), =>
      # update list of answers and comments
      @model.collection.fetch url: @options.parentModel.url
