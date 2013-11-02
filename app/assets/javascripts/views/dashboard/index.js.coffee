class Carrie.Views.DashboardIndex extends Backbone.Marionette.ItemView
  tagName: 'section'
  template: 'dashboard/index'

  initialize: ->
    @view = new Carrie.CompositeViews.ResquestLosToMe()

  onRender: ->
    $(@el).find('#requests-to-me').append(@view.el)
