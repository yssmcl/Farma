class Carrie.Models.SharedLo extends Backbone.RelationalModel
  urlRoot: '/api/los/shared'

  paramRoot: 'lo'

  defaults:
    'name': ''
    'description': ''
    'owner': ''

Carrie.Models.SharedLo.setup()
