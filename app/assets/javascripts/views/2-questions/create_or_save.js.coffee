class Carrie.Views.CreateOrSaveQuestion extends Backbone.Marionette.ItemView
  template: 'questions/form'
  className: 'question-form'

  events:
    'submit form': 'create'
    'click .btn-cancel': 'cancel'

  initialize: ->
    @prepareCkeditor()
    @modelBinder = new Backbone.ModelBinder()

  prepareCkeditor: ->
    if not @model
      Carrie.CKEDITOR.clearWhoHas("ckeditor-new")
      @cked = "ckeditor-new"
      @model = new Carrie.Models.Question
        exercise: @options.exercise
    else
      @cked = "ckeditor-#{@model.get('id')}"
      @editing = true

    Carrie.CKEDITOR.clearWhoHas("#{@cked}-tip")


  beforeClose: ->
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    Carrie.CKEDITOR.show "\##{@cked}"
    @addShowHideOrderOptionEvent()
    @showHideOrderOption()

  # When a answers have multiple answers
  # show option to consider its order
  addShowHideOrderOptionEvent: ->
    @cmas_group = $(@el).find(".cmas_order_group")
    @answer_input = $(@el).find(".correct_answer_group input")
    @answer_input.bind "change paste keyup", () =>
      @showHideOrderOption()

  showHideOrderOption: ->
    val = @answer_input.val()
    if val.indexOf(";") == -1
      @cmas_group.hide()
    else
      @cmas_group.show()


  cancel: (ev) ->
    ev.preventDefault()
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      @options.view.render()
    else
      $('#new_question').html('')

  create: (ev) ->
    ev.preventDefault()

    Carrie.Helpers.Notifications.Form.clear(@el)
    Carrie.Helpers.Notifications.Form.loadSubmit(@el)

    @model.set('content', CKEDITOR.instances[@cked].getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response, options) =>
        $(@el).find("\##{@cked}").ckeditorGet().destroy()

        Carrie.Helpers.Notifications.Form.resetSubmit(@el)
        Carrie.Helpers.Notifications.Top.success 'Questão salva com sucesso!', 4000

        if @editing
          @options.view.render()
        else
          view = new Carrie.Views.Question({model: @model})
          $("\##{@model.get('exercise').get('id')}").append view.render().el
          #$('#new_question').after view.render().el
          $('#new_question').html('')

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário', @l
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit(@el)
