@AL.module 'SearchApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "search/show/templates/show_layout"

    regions:
      headerRegion: "#searchbox"
      resultsRegion: "#results_region_search"

    events: {
      "click .clear-search": "clearSearch"
      "click button": "queryPassages"
    }
    clearSearch: ->
      # console.log 'clearSearch'
      Backbone.history.navigate("search", true)
      $("#q_input").val('')

    queryPassages: (e) =>
      q = $("#q_input").val()
      Backbone.history.navigate("search/" + q, true)


  # TODO: refactor? same functionality elsewhere
  class Show.SearchResult extends App.Views.ItemView
    template: "search/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.passage-link": "showOnePassage"
      "click span.placeref": "onPlacerefClick"
    }

    showOnePassage: (e) ->
      # console.log 'popup passage', $(e.currentTarget).context.attributes.val.value
      id = $(e.currentTarget).context.attributes.val.value
      # TODO: load passage in right panel
      AL.MapApp.Show.Controller.showOnePassage(id)

    onPlacerefClick: (e) ->
      window.context = $(e.currentTarget).context
      prid = $(e.currentTarget).context.attributes.val.value
      # -> @mapView.clickPlaceref(prid)
      App.vent.trigger 'placeref:click', {'id': prid}

  class Show.SearchResults extends App.Views.CompositeView
    template: "search/show/templates/_passages"
    childView: Show.SearchResult
    childViewContainer: "div"
