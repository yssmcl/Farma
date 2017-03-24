class Carrie.Views.BalancingReport extends Backbone.Marionette.ItemView
  template: 'reports/balancing/balancing_report'
  tagName: 'section'
  className: 'learners-reports'

  events:
    'change select[name="team"]' : 'loadLos'
    'change select[name="lo"]' : 'loadReport'

  initialize: ->
    @loadTeams()

  loadTeams: ->
    @teams = new Carrie.Collections.TeamsCreated()
    @teams.fetch
      async: false
      url: '/api/reports/my-created-teams'

  selectTeam: ->
    if @options.team_id
      @teamSelectTag.find("option[value=\"#{@options.team_id}\"]").attr('selected', 'selected')
      @fetchLos(@options.team_id)

  ######################## LOS #############################
  loadLos: (ev) ->
    ev.preventDefault()
    team_id = @teamSelectTag.find('option:selected').val()
    # update url
    Backbone.history.navigate("my-oa-balancing/teams/#{team_id}") if team_id != ""
    @fetchLos(team_id)

  fetchLos: (team_id) ->
    if team_id == ""
      @loSelectTag.html("<option value=\"\">Selectione um OA</option>")
      Backbone.history.navigate("my-oa-balancing")
      $(@el).find('.report').html ""
    else
      $.ajax
        url: "/api/reports/teams/#{team_id}/los"
        dataType: "json"
        success: (los) =>
          @buildLosOptions(los)
          @selectLo()

  buildLosOptions: (los) ->
    options = "<option value=\"\">Selecione um OA</option>"
    for lo in los
      options += "<option value='#{lo.id}'>#{lo.name}</option>"
    @loSelectTag.html(options)

  selectLo: ->
    if @options.team_id && @options.lo_id
      @loSelectTag.find("option[value=\"#{@options.lo_id}\"]").attr('selected', 'selected')
      @loadReport()
      @options.team_id = null
      @options.lo_id = null


  ######################## Report #############################
  loadReport: (ev) ->
    ev.preventDefault() if ev
    lo_id = @loSelectTag.find('option:selected').val()
    team_id = @teamSelectTag.find('option:selected').val()

    if lo_id == ""
      $(@el).find('.report').html ""
      Backbone.history.navigate("my-oa-balancing/teams/#{team_id}")
    else
      Backbone.history.navigate("my-oa-balancing/teams/#{team_id}/los/#{lo_id}")
      view = new Carrie.CompositeViews.BalancingReportTable(team_id: team_id, lo_id: lo_id)
      $(@el).find('.report').html view.render().el


  onRender: ->
    @teamSelectTag = $(@el).find('select[name="team"]')
    @loSelectTag = $(@el).find('select[name="lo"]')
    @selectTeam()

  serializeData: ->
    datas =
      teams: @teams.models
    return datas
