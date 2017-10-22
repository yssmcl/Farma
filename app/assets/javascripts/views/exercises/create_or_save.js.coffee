class Carrie.Views.CreateOrSaveExercise extends Backbone.Marionette.ItemView
  template: 'exercises/form'

  events:
    'submit form': 'create'

  initialize: ->
    @model = new Carrie.Models.Exercise({lo:@options.lo}) if not @model
    @modelBinder = new Backbone.ModelBinder()
    # @loadIntroductions()
    #@loadSubtopics

  onRender: ->
    @modelBinder.bind(@model, @el)
    Carrie.CKEDITOR.show()
    @checkboxes()
    # @introductionSelectTag = $(@el).find('select[name="introduction"]')
    # @selectIntroduction()

  beforeClose: ->
    $(@el).find("textarea").ckeditorGet().destroy()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear()
    Carrie.Helpers.Notifications.Form.loadSubmit()

    checkboxes = $(@el).find('.checkboxes input[type="checkbox"]')
    introduction_ids = checkboxes.serializeArray().map (el) ->
      el.value

    @model.set('introduction_ids', introduction_ids)

    # Get date from ckeditor and set in the model
    @model.set('content', CKEDITOR.instances.ckeditor.getData())

    console.log @model.attributes

    @model.save @model.attributes,
      wait: true
      success: (model, response, options) =>
        Carrie.Helpers.Notifications.Form.resetSubmit()
        #Backbone.history.navigate "/my-los/#{@options.lo.get('id')}/exercises/#{@model.get('id')}", true
        Backbone.history.navigate "/lo-contents/#{@options.lo.get('id')}", true
        Carrie.Helpers.Notifications.Top.success 'Exercício salvo com sucesso!', 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existem erros em seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()

  checkboxes: ->
    obj = $(@el).find('div.checkboxes')
    introduction_ids = @model.get('introduction_ids')
    introductions = new Carrie.Collections.Introductions()
    self = @

    introductions.fetch
      async: false
      url: "/api/los/#{@options.lo.get('id')}/introductions"
      success: (collection, resp) ->
        column = $('<div class="span4"></div>')
        amount = parseInt(collection.length / 3) + 1
        $.each collection.models, (index, el) ->
          checkbox = self.checkbox(el.get('title'), el.get('id'), introduction_ids)
          if index != 0 && index % amount == 0
            obj.append column
            column = $('<div class="span4"></div>')
          column.append checkbox

        obj.append column

  checkbox: (label, id, ids)->
    console.log '=== label: ' + label
    console.log '=== id: ' + id
    console.log '=== ids: '+ ids
    if jQuery.inArray(id, ids) != -1
      checked = 'checked'
    else
      checked = ''
    checkbox = "<label class='checkbox'>" +
                 "<input type='checkbox' name='introduction_ids' value='#{id}' #{checked} >" +
                 " #{label} " +
               "</label>"
    checkbox

  # serializeData: ->
  #   datas =
  #     introductions: @introductions.models
  #   return datas

  # loadIntroductions: ->
  #   @introductions = new Carrie.Collections.Introductions()
  #   @introductions.fetch
  #     async: false
  #     url: '/api/introductions/my-created-introductions'

  # selectIntroduction: ->
  #   if @options.introduction_id
  #     @introductionSelectTag.find("option[value=\"#{@options.introduction_id}\"]").attr('selected', 'selected')

  #loadSubtopics: ->
  #  @subtopics = new Carrie.Collections.SubtopicsCreated()
  #  @subtopics.fetch
  #    async: false
  #    url: '/api/my-created-subtopics'
