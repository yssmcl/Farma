class Carrie.Routers.Home extends Backbone.Marionette.AppRouter
  appRoutes:
    '': 'index'
    'dashboard': 'dashboard'
    'lo_example': 'lo_example'
    'lo_example/pages/:page': 'lo_example'
    '*options': 'urlNotFound'

class Carrie.Controllers.Home
  index: ->
    Carrie.main.show new Carrie.Views.HomeIndex
    $('.carousel').carousel
      interval: 7000

  dashboard: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.layouts.main = new Carrie.Views.Layouts.Main()
        Carrie.main.show Carrie.layouts.main

        Carrie.Utils.Menu.highlight 'dashboard-link'
        Carrie.layouts.main.content.show new Carrie.Views.DashboardIndex()

  lo_example: (page) ->
    lo = Carrie.Published.Models.Lo.findOrCreate()
    lo = new Carrie.Published.Models.Lo() if not lo

    lo.fetch
      url: '/api/home/lo_example'
      async: false
      success: (model, response, options) =>
        lo.set('url_page', "/lo_example")

        # Prepare layout
        Carrie.layouts.main = new Carrie.Views.Layouts.Main()
        Carrie.main.show Carrie.layouts.main
        $('#main-menu').remove()
        $('.toggle-menu').remove()
        $('#main-container').addClass('span12')

        Carrie.layouts.main.content.show new Carrie.Published.Views.Lo(model: lo, page: page)
      error: (model, response, options) =>
        alert('Objeto de Aprendizagme não encontrado!')
        Backbone.history.navigate('/', true)

  #The `*options` catchall route is a well known value in Backbone's Routing
  #internals that represents any route that's not listed before it. It should to
  #be defined last if desired. We'll just have the presenter render a 404-style
  #error view.
  urlNotFound: ->
    #Backbone.history.navigate('', true)
    #Carrie.Helpers.Notifications.Top.error 'Página não encontrada! Redirecionado para Home', 4000
