class Carrie.Models.Endless extends Backbone.Model
  url: ->
    @currentPage++
    "#{@get('root_url')}/page/#{@currentPage}"

  initialize: ->
    Carrie.Utils.Loading(@)
    @data = if @get('data') then @get('data') else {}
    @currentPage = 0
    @fetchData()
    @loading = null

  fetchData: ->
    @fetch
      #async: false
      data: @data
      success: =>
        @appendElements()

  currentPage: ->
    @currentPage

  reload: (params) ->
    @get('collection').reset()
    @set(@get('fecth_array'), [])
    @currentPage = 0
    @data = if params then params else {}
    @fetchData()

  load: ->
    self = @
    $(window).scroll ->
      if (($(window).scrollTop() > ($(document).height() - $(window).height() - 50)))
        if self.currentPage < self.get('total_pages') && not(@loading)
          @loading = self.fetch
            data: self.data
            success: ->
              @loading = null
              self.appendElements()

  appendElements: ->
    if @get(@get('fecth_array'))
      $.each @get(@get('fecth_array')), (index, el) =>
        @get('collection').add el

      if @get('call_back')
        @get('call_back').call()
