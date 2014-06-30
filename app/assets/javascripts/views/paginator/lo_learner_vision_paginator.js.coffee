class Carrie.Views.LoLearnerVisionPaginator extends Backbone.Marionette.ItemView
  template: 'paginator/lo_published'
  tagName: 'div'
  className: 'lo-paginator pagination pagination-centered'

  initialize: ->
    @model.bind 'reset', @render, this
    @length = @model.get('pages_count')
    @page = 0
    @parentView = @options.parentView

  events:
    'change #page-select': 'changePage'
    'click #next-page': 'nextPage'
    'click #prev-page': 'prevPage'

  changePage: (ev) ->
    ev.preventDefault()
    @page = parseInt($(ev.target).val())
    @showPage()

  firstPage: (ev) ->
    ev.preventDefault()
    @page = 0
    @showPage()

  lastPage: (ev) ->
    ev.preventDefault()
    @page = @length-1
    @showPage()

  nextPage: (ev) ->
    ev.preventDefault()
    if @page+1 < @length
      @page += 1
      @showPage()

  prevPage: (ev) ->
    ev.preventDefault()
    if @page > 0
      @page -= 1
      @showPage()

  modelType: ->
    $(@el).find('select#page-select option:selected').data('type')

  pageCollection: ->
    $(@el).find('select#page-select option:selected').data('page-collection')

  showPage: (type) ->
    $(@el).find('select#page-select').val(@page)

    if @modelType() is 'introduction'
      view = new Carrie.Published.Views.Introduction
        model: @model.get('introductions').at(@pageCollection())
    else
      view = new Carrie.Views.LearnerVisionExercise model: @model.get('exercises').at(@pageCollection()), learner_id: @options.learner_id

    $(@parentView.el).find('section.page').html(view.render().el)

  onRender: ->
    @showPage()

