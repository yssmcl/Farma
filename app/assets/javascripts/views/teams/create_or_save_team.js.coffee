class Carrie.Views.CreateOrSaveTeam extends Backbone.Marionette.ItemView
  template: 'teams/form'

  events:
    'submit form': 'create'

  initialize: ->
    @model = new Carrie.Models.Team() if not @model
    @modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(@model, @el)
    @checkboxes()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear()
    Carrie.Helpers.Notifications.Form.loadSubmit()

    checkboxes = $(@el).find('.checkboxes input[type="checkbox"]')
    lo_ids = checkboxes.serializeArray().map (el) ->
      el.value

    @model.set('lo_ids', lo_ids)
    if @model.isNew()
      msg = 'Turma criada com sucesso!'
    else
      msg = 'Turma atualizada com sucesso!'

    @model.save @model.attributes,
      wait: true
      success: (lo, response) =>
        Carrie.Helpers.Notifications.Form.resetSubmit()

        Backbone.history.navigate "/teams/created", true
        Carrie.Helpers.Notifications.Top.success msg, 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()

  checkboxes: ->
    obj = $(@el).find('div.checkboxes')
    lo_ids = @model.get('lo_ids')
    los = new Carrie.Collections.Los()
    self = @

    los.fetch
      success: (collection, resp) ->
        column = $('<div class="span4"></div>')
        amount = parseInt(collection.length / 3) + 1
        $.each collection.models, (index, el) ->
          checkbox = self.checkbox(el.get('name'), el.get('id'), lo_ids)
          if index != 0 && index % amount == 0
            obj.append column
            column = $('<div class="span4"></div>')
          column.append checkbox

        obj.append column

  checkbox: (label, id, ids)->
    if jQuery.inArray(id, ids) != -1
      checked = 'checked'
    else
      checked = ''
    checkbox = "<label class='checkbox'>" +
                 "<input type='checkbox' name='lo_ids' value='#{id}' #{checked} >" +
                 " #{label} " +
               "</label>"
    checkbox
