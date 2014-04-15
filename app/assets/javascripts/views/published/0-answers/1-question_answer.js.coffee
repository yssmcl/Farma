class Carrie.Published.Views.QuestionAnswer extends Backbone.Marionette.ItemView
  template: 'published/answers/index_item'
  tagName: 'tr'

  events:
    'click' : 'retro'

  retro: (ev) ->
    Carrie.Helpers.Retroaction.open @model.get('id')
