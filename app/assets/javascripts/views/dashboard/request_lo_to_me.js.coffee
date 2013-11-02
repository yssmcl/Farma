class Carrie.Views.RequestLoToMeItem extends Backbone.Marionette.ItemView
  template: 'dashboard/request_to_me'
  tagName: 'article'

  events:
    'click .share' : 'share'
    'click .not-share' : 'not_share'

  share: (ev) ->
    ev.preventDefault()

    $.post("/api/requests/#{@model.get('id')}/authorize", () =>
       Carrie.Helpers.Notifications.Top.success 'Autorização realizada com sucesso!', 3000
       btn = $(ev.target);
       btn.removeClass('btn-primary request-lo share').addClass('btn-success disabled')
       btn.html('Compartilhado')
       $(@el).find('.not-share').remove()
    ).fail () ->
       console.log 'Request fail!'

  not_share: (ev) ->
    ev.preventDefault()

    $.post("/api/requests/#{@model.get('id')}/not-authorize", () =>
       btn = $(ev.target);
       btn.removeClass('btn-primary request-lo not-share').addClass('btn-danger disabled')
       btn.html('Não compartilhado')
       $(@el).find('.share').remove()
    ).fail () ->
       console.log 'Request fail!'
