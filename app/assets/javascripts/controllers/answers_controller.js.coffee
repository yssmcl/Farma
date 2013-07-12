class Carrie.Routers.Answers extends Backbone.Marionette.AppRouter
  appRoutes:
    'answers/my': 'my'
    'answers/teams-enrolled': 'teams_enrolled'
    'answers/teams-created': 'teams_created'

class Carrie.Controllers.Answers

  my: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: 'Minhas Respostas', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers([], url: '/api/answers/my')
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection
           url: '/api/answers/my'
           teams_url: '/api/teams/enrolled'
           title: 'Minhas respostas'
           subTitle: 'Nesta página você pode rever todos seus erros e acertos. Clicando em uma das resposta
                      é possível voltar ao momento exato de sua ocorrência.'

        Carrie.layouts.main.content.show view

  teams_enrolled: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'teams-enrolled-answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: 'Respostas das turmas que participo', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers([], url: '/api/answers/search-in-teams-enrolled')
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection
           url: '/api/answers/search-in-teams-enrolled'
           teams_url: '/api/teams/enrolled'
           title: 'Respostas dos participantes das turmas que estou matriculado'
           subTitle: 'Nesta página você pode rever todos os erros de seus colegas. Clicando em uma das resposta
                      é possível voltar ao momento exato de sua ocorrência.  Retrocedento a um resposta você
                      também pode enviar comentários ao aprendiz'

        Carrie.layouts.main.content.show view

  teams_created: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'teams-created-answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: 'Respostas das turmas que criei', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers([], url: '/api/answers/search-in-teams-created')
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection
           url: '/api/answers/search-in-teams-created'
           teams_url: '/api/teams/created'
           filter_by_learner: true
           title: 'Respostas dos participantes das turmas que você criou'
           subTitle: 'Nesta página você pode rever todos os erros e acertos dos participantes das turmas que você
                      criou. Clicando em uma das resposta
                      é possível voltar ao momento exato de sua ocorrência. Retrocedento a um resposta você também pode
                      enviar comentários ao aprendiz'

        Carrie.layouts.main.content.show view
