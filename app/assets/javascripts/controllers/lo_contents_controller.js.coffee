class Carrie.Routers.LoContents extends Backbone.Marionette.AppRouter
  appRoutes:
    'lo-contents/:lo_id': 'index'

class Carrie.Controllers.LoContents

  index: (lo_id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        contents = new Carrie.Collections.LoContents
        contents.fetch
          async: false
          url: "/api/lo-contents/#{lo_id}"
          error: ->
            alert('Objeto de aprendizagem não encontrado')
            Backbone.history.navigate('/my-los', true)

        contentsView = new Carrie.CompositeViews.LoContentsIndex
          collection: contents

        obj = Carrie.Utils.Menu.highlight 'my-los-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: obj.text(), url: obj.data('url')
          2: name: contents.lo.name, url: "#"

        Carrie.layouts.main.content.show contentsView

