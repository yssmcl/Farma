class Carrie.Published.Views.LoAutoSequence extends Backbone.Marionette.ItemView
  template: 'published/los/show'
  tagName: 'section'

  initialize: ->
    @paginator = new Carrie.Published.Views.LoAutoSequencePaginator
      model: @model
      parentView: @
      page: @options.page-1 || 0
      team: @model.get('team')

  reload: ->
    @model.fetch
      async: false
      success: (model) =>
        @render()

  onRender: ->
    @el.id = @model.get('id')
    if @model.get('pages_count') > 0
      $(@el).find('.navigator').html(@paginator.render().el)
    else
      Carrie.layouts.main.reloadBreadcrumb()
      team =  "Turma #{@model.get('team').get('name')} / "
      bread = "#{team} Objeto de aprendizagem #{@model.get('name')}"
      Carrie.layouts.main.addBreadcrumb(bread, '', false)

      $(@el).find('.page').html('Objeto de aprendizagem sem publicações')

