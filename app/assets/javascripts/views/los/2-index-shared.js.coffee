class Carrie.CompositeViews.SharedLos extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'los/index-shared'
  itemView: Carrie.Views.SharedLo

  events:
    'submit .form-search': 'search'

  initialize: ->
    @collection = new Carrie.Collections.SharedLos()
    @endless = new Carrie.Models.Endless
      root_url: '/api/los/shared'
      collection: @collection
      fecth_array: 'los'

  onRender: ->
    @endless.load()

  search: (ev) ->
    ev.preventDefault()
    @endless.reload search: $(@el).find('.form-search input').val()
