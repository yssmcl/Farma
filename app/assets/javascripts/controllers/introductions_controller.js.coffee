class Carrie.Routers.Introductions extends Backbone.Marionette.AppRouter
  appRoutes:
    'my-los/:lo_id/introductions/new': 'new'
    'my-los/:lo_id/introductions/edit/:id': 'edit'

class Carrie.Controllers.Introductions

  new: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-los-link'
        lo = @findLo(lo_id)

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
          2: name: "Conteúdos do OA #{lo.get('name')}", url: "/lo-contents/#{lo.get('id')}"
          3: name: 'nova', url: ''

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveIntroduction(lo: lo)

  edit: (lo_id, id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-los-link'
        lo = @findLo(lo_id)
        introduction = @findIntro(lo, id)

        introduction.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
              2: name: "Conteúdos do OA #{lo.get('name')}", url: "/lo-contents/#{lo.get('id')}"
              3: name: "Editar introdução #{model.get('title')}", url: ''

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveIntroduction(lo: lo, model: model)

          error: (model, response, options)->
            alert('Introdução não encontrada!')
            Backbone.history.navigate('/my-los', true)

  findLo: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)
    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response, options) ->
          alert('Objeto de aprendizagem não encontrado!')
          Backbone.history.navigate('/my-los', true)
    return lo

  findIntro: (lo, id) ->
    intro = Carrie.Models.Introduction.findOrCreate(id)
    intro = new Carrie.Models.Introduction({lo: lo, id: id}) if not intro
    return intro
