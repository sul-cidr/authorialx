@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    buildPopup: (params) ->
      @mapView.buildPopup params

    showMap: ->
      @mapView = @getMapView()

      App.mapRegion.show @mapView
      # $("#spin_map").addClass('hidden')

    getMapView: ->
      new Show.Map

    swapBase: (id) ->
      @mapView.swapBase id

    # params can be any of author_id:, work_id:, work_cat:, auth_cat
    # normally with clear:true
    filterPlaces: (params) ->
      # console.log 'filterPlaces', params
      @mapView.renderPlaces(params)

    renderOneAuthor: (params) ->
      # console.log 'renderOneAuthor() -> renderPlaces(),renderImages()', params
      @mapView.renderPlaces(params)

    # CHECK: not in use
    # mapImages: (params) ->
    #   @mapView.mapImages(params)

    dropOneAuthor: (params) ->
      # console.log 'dropOneAuthor() sending removePlaces():', params
      @mapView.removePlaces(params)

    resetMap: ->
      # console.log 'resetMap() fired'
      $("#gallery_region").addClass("hidden")
      @mapView.renderPlaces({clear:true})
      @mapView.clearKeyPlaces()

    clearAuthors: ->
      @mapView.clearKeyPlaces()

    zoomTo: (what, area) ->
      @mapView.zoomTo what, area

    # TODO: is this in effect?
    filterByArea: (type, b) ->
      window.counter = 0
      # console.log "bounds to turf from hoods:", b
      @setFilter 'area', (placeref) ->
      # MapApp.Show.Controller.setFilter 'area', (placeref) ->
        counter += 1
        # console.log turf.point( wellknown(placeref.attributes.geom_wkt).coordinates )

        # b is a hood voronoi polygon geojson object a
        turf.inside( turf.point(wellknown(placeref.get("geom_wkt")).coordinates), b )
        # b is a viewport

    # /**
    #  * Unhighlight all; part of map:reset
    #  */
    unhighlightAll: ->
      @mapView.unhighlightAll()

    # /**
    # from on map_app "placeref:click"
    # Go to view
    # */
    onClickPlaceref: (prid) ->
      @mapView.clickPlaceref(prid);

    # /**
    #  * Highlight a place.
    #  */
    onHighlightFeature: (prid) ->
      @mapView.highlightFeature(prid);

    # /**
    #  * Unhighlight a place.
    #  */
    onUnhighlightFeature: (prid) ->
      @mapView.unhighlightFeature(prid);

    # /**
    #  * Focus on a place.
    #  */
    onSelectFeature: (what, id) ->
      @mapView.selectFeature(what, id);

    #
    showOnePassage: (passage_id) ->
      # retrieve single passage
      $("#place_passages_region").removeClass('hidden')
      App.request "passage:place", passage_id, (place_passages) =>
        window.placepassage = place_passages
        placePassageView = @getPlacePassageView place_passages

        App.placePassagesRegion.show placePassageView
        App.placePassagesRegion.$el.fadeIn("slow")

    getPlacePassageView: (place_passages) ->
      new AL.PlacesApp.Show.PlacePassages ({
        collection: place_passages
        className: 'passages-places'
      })
