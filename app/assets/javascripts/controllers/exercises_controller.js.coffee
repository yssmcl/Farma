class Carrie.Routers.Exercises extends Backbone.Marionette.AppRouter
  appRoutes:
    'my-los/:lo_id/exercises/new': 'new'
    'my-los/:lo_id/exercises/edit/:id': 'edit'
    'my-los/:lo_id/exercises/:id': 'show'

class Carrie.Controllers.Exercises

  new: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-los-link'
        lo = @findLo(lo_id)
        return unless lo
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
          2: name: "Conteúdos do OA #{lo.get('name')}", url: "/lo-contents/#{lo.get('id')}"
          3: name: 'novo', url: ''

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveExercise(lo: lo)

  edit: (lo_id, id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-los-link'
        lo = @findLo(lo_id)
        return unless lo
        exercise = @findExer(lo, id)

        exercise.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
              2: name: "Conteúdos do OA #{lo.get('name')}", url: "/lo-contents/#{lo.get('id')}"
              3: name: "Editar exercício #{model.get('title')}", url: ''

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveExercise(lo: lo, model: model)
          error: (model, response, options) ->
            alert('Exercício não encontrado!')
            Backbone.history.navigate("/lo-contents/#{lo.get('id')}", true)

  show: (lo_id, id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-los-link'
        lo = @findLo(lo_id)
        return unless lo
        exercise = @findExer(lo, id)
        exercise.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
              2: name: "Conteúdos do OA #{lo.get('name')}", url: "/lo-contents/#{lo.get('id')}"
              3: name: "Visualizando exercício #{model.get('title')}", url: ''

            Carrie.layouts.main.content.show new Carrie.CompositeViews.ExerciseShow(lo: lo, model: exercise)
          error: (model, response, options) ->
            alert('Exercício não encontrado!')
            Backbone.history.navigate("/lo-contents/#{lo.get('id')}", true)


  findLo: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)
    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response, options) ->
          lo = null
          alert('Objeto de aprendizagem não encontrado!')
          Backbone.history.navigate('/my-los', true)
    return lo

  findExer: (lo, id) ->
    exer = Carrie.Models.Exercise.findOrCreate(id)
    exer = new Carrie.Models.Exercise({lo: lo, id: id}) if not exer
    return exer
