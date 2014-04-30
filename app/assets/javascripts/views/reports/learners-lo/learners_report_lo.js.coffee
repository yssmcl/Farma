class Carrie.Views.LearnersReportLo extends Backbone.Marionette.ItemView
  template: 'reports/learner-lo/select-options'
  tagName: 'section'
  className: 'learners-reports'

  events:
    'change select[name="team"]' : 'loadLosAndUsers'
    'change select[name="lo"]' : 'selectedLo'
    'change select[name="learner"]' : 'loadReport'

  initialize: ->
    @loadTeams()

  loadTeams: ->
    @teams = new Carrie.Collections.TeamsCreated()
    @teams.fetch
      async: false
      url: '/api/reports/my-created-teams'


  ######################## Learner and Los #############################
  loadLosAndUsers: (ev) ->
    ev.preventDefault()
    team_id = @teamSelectTag.find('option:selected').val()
    Backbone.history.navigate("reports/my-learners/teams/#{team_id}") if team_id != "" # update url
    @fetchLosAndUsers(team_id)

  fetchLosAndUsers: (team_id) ->
    if team_id == ""
      @loSelectTag.html("<option value=\"\">Selectione um OA</option>")
      @learnerSelectTag.html("<option value=\"\">Selectione um Aprendiz</option>")
      Backbone.history.navigate("reports/my-learners")
      $(@el).find('.report').html ""
    else
      $.ajax
        url: "/api/reports/teams/#{team_id}/learners-and-los"
        dataType: "json"
        success: (data) =>
          @buildLosOptions(data.los)
          @buildLearnersOptions(data.learners)
          @selectLoAndLeaner()

  buildLearnersOptions: (learners) ->
    options = "<option value=\"\">Selecione um Aprendiz</option>"
    for learner in learners
      options += "<option value='#{learner.id}'>#{learner.name}</option>"
    @learnerSelectTag.html(options)

  buildLosOptions: (los) ->
    options = "<option value=\"\">Selecione um OA</option>"
    for lo in los
      options += "<option value='#{lo.id}'>#{lo.name}</option>"
    @loSelectTag.html(options)

  selectedLo: (ev) ->
    ev.preventDefault()
    lo_id = @loSelectTag.find('option:selected').val()
    team_id = @teamSelectTag.find('option:selected').val()

    if lo_id == ""
      $(@el).find('.report').html ""
      @learnerSelectTag.find("option[value='']").attr('selected', 'selected')
      Backbone.history.navigate("reports/my-learners/teams/#{team_id}")
    else
      Backbone.history.navigate("reports/my-learners/teams/#{team_id}/los/#{lo_id}")

  ######################## Report #############################
  loadReport: (ev) ->
    ev.preventDefault() if ev
    lo_id = @loSelectTag.find('option:selected').val()
    team_id = @teamSelectTag.find('option:selected').val()
    learner_id = @learnerSelectTag.find('option:selected').val()

    if (learner_id == "" && lo_id != "")
      $(@el).find('.report').html ""
      Backbone.history.navigate("reports/my-learners/teams/#{team_id}/los/#{lo_id}")
    else
      if (learner_id != "" && lo_id != "")
        Backbone.history.navigate("reports/my-learners/teams/#{team_id}/los/#{lo_id}/learners/#{learner_id}")
        view = new Carrie.CompositeViews.LearnersReportLoTable(team_id: team_id, lo_id: lo_id, learner_id: learner_id)
        $(@el).find('.report').html view.render().el
      else
        alert "Selecione primeiro o OA"
        @learnerSelectTag.find("option[value='']").attr('selected', 'selected')


  ######################## Load from url #############################
  selectTeam: ->
    if @options.team_id
      @teamSelectTag.find("option[value=\"#{@options.team_id}\"]").attr('selected', 'selected')
      @fetchLosAndUsers(@options.team_id)

  selectLoAndLeaner: ->
    if @options.team_id && @options.lo_id
      @loSelectTag.find("option[value=\"#{@options.lo_id}\"]").attr('selected', 'selected')

      if @options.learner_id 
        @learnerSelectTag.find("option[value=\"#{@options.learner_id}\"]").attr('selected', 'selected')
        @loadReport()

      @options.team_id = null
      @options.lo_id = null
      @options.learner_id = null

  onRender: ->
    @teamSelectTag = $(@el).find('select[name="team"]')
    @loSelectTag = $(@el).find('select[name="lo"]')
    @learnerSelectTag = $(@el).find('select[name="learner"]')
    @selectTeam()

  serializeData: ->
    datas =
      teams: @teams.models
    return datas

