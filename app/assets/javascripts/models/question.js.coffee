class Carrie.Models.Question extends Backbone.RelationalModel
  urlRoot: ->
    '/api/los/' + @get('exercise').get('lo').get('id') + '/exercises/' + @get('exercise').get('id') + '/questions'

  paramRoot: 'question'

  relations: [{
    type: Backbone.HasMany
    key: 'tips'
    relatedModel: 'Carrie.Models.Tip'
    collectionType: 'Carrie.Collections.Tips'
    reverseRelation: {
      key: 'question'
    }
  },
  {
    type: Backbone.HasMany
    key: 'answers'
    relatedModel: 'Carrie.Models.Answer'
    collectionType: 'Carrie.Collections.Answers'
    reverseRelation: {
      key: 'question'
    }
  }
  ]

  defaults:
    'title': ''
    'content': ''
    'comparation_type': 'expression'
    'cmas_order': true
    'precision': 5

  toJSON: ->
    id: @get('id')
    title: @get('title')
    content: @get('content')
    correct_answer: @get('correct_answer')
    available: @get('available')
    precision: @get('precision')
    cmas_order: @get('cmas_order')
    many_answers: @get('many_answers')
    lo_id: @get('exercise').get('lo').get('id')
    exercise_id: @get('exercise').get('id')

Carrie.Models.Exercise.setup()
