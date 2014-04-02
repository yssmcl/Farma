class Carrie.Views.LoContentsIndexItem extends Backbone.Marionette.ItemView
  template: 'lo_contents/index_item'
  tagName: 'article'
  className: 'header'

  events:
    'click .show_questions' : 'questions'
    'click .show_content' : 'show'
    'click .edit' : 'edit'
    'click .destroy' : 'destroy'

  questions: (ev) ->
    @prepare(ev)
    id = @model.get('id')
    url = "/my-los/#{@model.get('lo').id}/#{@model.contentOf()}/#{id}"
    Backbone.history.navigate(url, true)

  show: (ev) ->
    @prepare(ev)
    $(@el).find('span i').tooltip('hide')
    $(@el).find('.content').toggle('blind', {}, 500)

  edit: (ev) ->
    @prepare(ev)
    id = @model.get('id')
    url = "/my-los/#{@model.get('lo').id}/#{@model.contentOf()}/edit/#{id}"
    Backbone.history.navigate(url, true)

  destroy: (ev) ->
    @prepare(ev)
    msg = "Você tem certeza que deseja remover este(a) #{@model.get('type')}?"
    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          success: (model, response) =>
            $(@el).fadeOut(800, 'linear')

            Carrie.Helpers.Notifications.Top.success "#{@model.get('type')} removido com sucesso!", 4000

  onRender: ->
    @el.id = @model.get('id')
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  prepare: (ev) ->
    ev.preventDefault()
    $(@el).find('span i').tooltip('hide')


