class Carrie.Routers.Reports extends Backbone.Marionette.AppRouter
  appRoutes:
    'my-progress': 'myProgress'
    'my-learners-progress': 'myLearnersProgress'
    'my-learners-progress/teams/:team_id': 'myLearnersProgress'
    'my-learners-progress/teams/:team_id/los/:lo_id': 'myLearnersProgress'

class Carrie.Controllers.Reports

  myProgress: ->
    Carrie.Helpers.Session.Exists
      func: =>
        obj = Carrie.Utils.Menu.highlight 'my-progress-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: obj.text(), url: obj.data('url')
          2: name: "Progresso", url: "#"

        collection = new Carrie.Collections.LosForReport
        collection.fetch
          url: '/api/reports/my-teams-los'

        view = new Carrie.CompositeViews.CurrentUserReportTable
          collection: collection

        Carrie.layouts.main.content.show view

  myLearnersProgress: (team_id, lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        obj = Carrie.Utils.Menu.highlight 'my-learners-progress-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: obj.text(), url: obj.data('url')
          2: name: "Progresso", url: "#"

        view = new Carrie.Views.LearnersReport(team_id: team_id, lo_id: lo_id)
        Carrie.layouts.main.content.show view
