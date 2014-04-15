class Carrie.Routers.LearnerReportTimeline extends Backbone.Marionette.AppRouter
  appRoutes:
    'reports/teams/:team_id/los/:lo_id/timeline/:user_id': 'timeline'
    'reports/my-timeline/teams/:team_id/los/:lo_id': 'myTimeline'

class Carrie.Controllers.LearnerReportTimeline

  timeline: (team_id, lo_id, user_id) ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'my-learners-progress-link'
        Carrie.layouts.main.hideMenu()

        url = "my-learners-progress/teams/#{team_id}/los/#{lo_id}"
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus aprendizes', url: url
          2: name: 'Timeline', url: ''

        view = new Carrie.Views.LearnerReportTimeline
           url: "/api/reports/teams/#{team_id}/los/#{lo_id}/timeline/#{user_id}"
           backUrl: "/my-learners-progress/teams/#{team_id}/los/#{lo_id}"

         Carrie.layouts.main.content.show view

  myTimeline: (team_id, lo_id) ->
     Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'my-progress-link'
        Carrie.layouts.main.hideMenu()

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Progresso', url: "my-progress"
          2: name: 'Timeline', url: ''

        view = new Carrie.Views.LearnerReportTimeline
           url: "/api/reports/my-timeline/teams/#{team_id}/los/#{lo_id}"
           backUrl: "/my-progress"

         Carrie.layouts.main.content.show view

        #view = new Carrie.Views.LearnerReportTimeline
        #  team_id: team_id
        #  lo_id: lo_id
        #  user_id: user_id

        #Carrie.layouts.main.content.show view
