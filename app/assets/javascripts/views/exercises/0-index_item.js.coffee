class Carrie.Views.ExerciseIndexItem extends Backbone.Marionette.ItemView
  template: 'exercises/index_item'
  tagName: 'article'
  className: 'header'

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('span.icon i').tooltip()

  events:
    'click #show_exer' : 'show'
    'click #edit_exer' : 'edit'
    'click #destroy_exer' : 'destroy'

  show: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate('/my-los/'+@model.get('lo').get('id')+'/exercises/'+@el.id, true)

  edit: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate('/my-los/'+@model.get('lo').get('id')+'/exercises/edit/'+@el.id, true)

  destroy: (ev) ->
    ev.preventDefault()
    msg = "Você tem certeza que deseja remover este exercício?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          success: (model, response) =>
            $(@el).fadeOut(800, 'linear')

            Carrie.Helpers.Notifications.Top.success 'Exercício removido com sucesso!', 4000
