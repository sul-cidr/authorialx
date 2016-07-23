@AL.module "PlacesApp", (PlacesApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  class PlacesApp.Router extends Marionette.AppRouter
    appRoutes:
      "places/:id": "showPlace"

  API =
    startPlaces: ->
      PlacesApp.List.Controller.startPlaces()

    listPlaces: ->
      PlacesApp.List.Controller.listPlaces()

    showPlaceSummary: (activePlacerefs) ->
      PlacesApp.Show.Controller.showPlaceSummary(activePlacerefs)

    # these go and do a spatial filter
    showPlace: (id) ->
      PlacesApp.Show.Controller.showPlace(id)

  App.vent.on "place:show", (area) ->
    id = area.get("id")
    # console.log 'place:show triggered', id
    Backbone.history.navigate("places/" + id)
    API.showPlace(id)

  App.vent.on "placerefs:area", (activePlacerefs) ->
    # CHECK: placeref filtering happens from both directions
    # this renders Area Summary whether visible or not
    # console.log 'activePlacerefs', activePlacerefs.length
    API.showPlaceSummary activePlacerefs

  PlacesApp.on "start", ->
    new PlacesApp.Router
      controller: API
    # API.startPlacess()
