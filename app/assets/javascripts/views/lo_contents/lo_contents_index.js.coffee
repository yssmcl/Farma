class Carrie.CompositeViews.LoContentsIndex extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'lo_contents/index'
  itemView: Carrie.Views.LoContentsIndexItem

  events:
    'click #add_intro' : 'newIntro'
    'click #add_exer'  : 'newExercise'

  initialize: ->
    @lo = @collection.lo

  serializeData: ->
    viewData =
      lo: @lo
    return viewData

  newIntro: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate("/my-los/#{@lo.id}/introductions/new", true)

  newExercise: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate("/my-los/#{@lo.id}/exercises/new", true)

  onRender: ->
    $(@el).find('span i').tooltip()
    @sortOption()

  sortOption: ->
    url = "/api/lo-contents/#{@lo.id}/sort"
    $(@el).sortable
      handle: '.move'
      axis: 'y'
      items: 'article'
      update: (event, ui) ->
        $.post(url, { 'ids' : $(@).sortable('toArray') })
