class Carrie.Routers.Answers extends Backbone.Marionette.AppRouter
  appRoutes:
    'answers/my/:retro_to_id': 'my'
    'answers/my': 'my'

    'answers/teams-enrolled/:retro_to_id': 'teams_enrolled'
    'answers/teams-enrolled': 'teams_enrolled'

    'answers/teams-created/:retro_to_id': 'teams_created'
    'answers/teams-created': 'teams_created'

class Carrie.Controllers.Answers

  my: (retro_to_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'my-answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
          2: name: 'Minhas Respostas', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers([], url: '/api/answers/my')
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection
           url: '/api/answers/my'
           teams_url: '/api/teams/enrolled'
           retro_to_id: retro_to_id
           title: 'Minhas respostas'
           subTitle: 'Nesta página você pode rever todos seus erros e acertos. Clicando em uma das resposta
                      é possível voltar ao momento exato de sua ocorrência.'


        Carrie.layouts.main.content.show view

  teams_enrolled: (retro_to_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'teams-enrolled-answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
          2: name: 'Respostas das turmas que participo', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers([], url: '/api/answers/search-in-teams-enrolled')
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection
           url: '/api/answers/teams-enrolled'
           teams_url: '/api/teams/enrolled'
           retro_to_id: retro_to_id
           not_filter_by_answers: true
           title: 'Minhas respostas'
           title: 'Respostas dos participantes das turmas que estou matriculado'
           subTitle: 'Nesta página você pode rever todos os erros de seus colegas. Clicando em uma das resposta
                      é possível voltar ao momento exato de sua ocorrência.  Retrocedento a um resposta você
                      também pode enviar comentários ao aprendiz'

        Carrie.layouts.main.content.show view

  teams_created: (retro_to_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'teams-created-answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Meus Objetos de Aprendizagem', url: '/my-los'
          2: name: 'Respostas das turmas que criei', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers([], url: '/api/answers/search-in-teams-created')
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection
           url: '/api/answers/teams-created'
           teams_url: '/api/teams/created'
           retro_to_id: retro_to_id
           filter_by_learner: true
           title: 'Respostas dos participantes das turmas que você criou'
           subTitle: 'Nesta página você pode rever todos os erros e acertos dos participantes das turmas que você
                      criou. Clicando em uma das resposta
                      é possível voltar ao momento exato de sua ocorrência. Retrocedento a um resposta você também pode
                      enviar comentários ao aprendiz'

        Carrie.layouts.main.content.show view
