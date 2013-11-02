class Carrie.Views.SharedLo extends Backbone.Marionette.ItemView
  template: 'los/show-shared'
  tagName: 'article'
  className: 'header'

  events:
    'click .preview' : 'preview'
    'click .request-lo' : 'request'

  onRender: ->
    $(@el).find('a[data-toggle="tooltip"]').tooltip({placement: 'bottom'})

  preview: (ev) ->
    ev.preventDefault()
    url = "/published/los/#{@model.get('id')}"
    Backbone.history.navigate(url, true)

  request: (ev) ->
    ev.preventDefault()
    $.post("/api/requests/#{@model.get('id')}", () ->
       Carrie.Helpers.Notifications.Top.success 'Requisição enviada com sucesso!', 3000
       btn = $(ev.target);
       btn.removeClass('btn-primary request-lo').addClass('btn-success disabled')
       btn.html('Aguardando autorização');
       btn.tooltip('destroy')
    ).fail () ->
       console.log 'Request fail!'

