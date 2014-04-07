class Carrie.Routers.Los extends Backbone.Marionette.AppRouter
  appRoutes:
    'my-los': 'list'
    'my-los/new': 'new'
    'my-los/edit/:id': 'edit'
    'help' : 'showHelp'
    'shared-los': 'list_shared'

class Carrie.Controllers.Los

  list_shared: ->
    Carrie.Helpers.Session.Exists
      func: ->
        obj = Carrie.Utils.Menu.highlight 'shared-los-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem compartilhados', url: obj.data('url')

        Carrie.layouts.main.content.show new Carrie.CompositeViews.SharedLos

  list: ->
    Carrie.Helpers.Session.Exists
      func: ->
        los = new Carrie.Collections.Los
        losView = new Carrie.CompositeViews.Los collection: los

        obj = Carrie.Utils.Menu.highlight 'my-los-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: obj.text(), url: obj.data('url')

        Carrie.layouts.main.content.show losView
        los.fetch()

  new: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'my-los-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
          2: name: 'novo', url: '/my-los/new'

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveLo()

  edit: (id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-los-link'

        lo = Carrie.Models.Lo.findOrCreate(id)
        lo = new Carrie.Models.Lo({id: id}) if not lo

        lo.fetch
          success: (model, response, options) ->
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
              2: name: "Editar OA #{model.get('name')}", url: '/my-los/edit'

            Carrie.layouts.main.content.close()
            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveLo(model: lo)
          error: ->
            alert('Objeto de aprendizagem não encontrado!')
            Backbone.history.navigate('/my-los', true)


  showHelp: ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'help-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Ajuda com a FARMA', url: ''

        Carrie.layouts.main.content.show new Carrie.Views.Help()
