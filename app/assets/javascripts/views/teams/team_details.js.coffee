class Carrie.Views.TeamDetails extends Backbone.Marionette.ItemView
  template: 'teams/team_details'
  tagName: 'article'

  events:
    'click .calculates-calibration' : 'startCalibration'
    'click .calculates-progress' : 'startProgressUpdate'

  startCalibration: (ev) ->
    ev.preventDefault()
    team_id = @model.get('id')
    lo_id = $(ev.currentTarget).data('id')

    $(@el).find("a.calculates-calibration").html('loading...')
    $(@el).find("a.calculates-calibration").addClass('disabled')

    $.ajax({
      url: "/api/sequence/teams/#{team_id}/los/#{lo_id}"
      type: 'POST'
      success: (model, response, options) =>
        console.log "Concluído"
        alert "Calibragem Concluída"
        $(@el).find("a.calculates-calibration").html('Efetuar Calibragem')
        $(@el).find("a.calculates-calibration").removeClass('disabled')
      error: (model, response, options) ->
        console.log "Error"
    })

  startProgressUpdate: (ev) ->
    ev.preventDefault()
    team_id = @model.get('id')
    lo_id = $(ev.currentTarget).data('id')

    $(@el).find("a.calculates-progress").html('loading...')
    $(@el).find("a.calculates-progress").addClass('disabled')

    $.ajax({
      url: "/api/reports/teams/#{team_id}/los/#{lo_id}"
      type: 'POST'
      success: (model, response, options) =>
        console.log "Concluído"
        alert "Atualização Concluída"
        $(@el).find("a.calculates-progress").html('Efetuar Atualização de Progresso')
        $(@el).find("a.calculates-progress").removeClass('disabled')
      error: (model, response, options) ->
        console.log "Error"
    })

  onRender: ->
    $(@el).find('a.calculates-calibration').tooltip()
    $(@el).find('a.calculates-progress').tooltip()
