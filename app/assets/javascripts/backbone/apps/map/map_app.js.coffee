@AL.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  App.vent.on "authors:show", (authids) ->
    # console.log "map heard authors:show -->", authids
    # placerefs for all passages by one or more authors
    API.filterByAuthors authids

  App.vent.on "author:checked", (params) ->
    API.renderOneAuthor params

  App.vent.on "author:unchecked", (params) ->
    API.dropOneAuthor params

  App.vent.on "work:show", (work) ->
    # console.log "map heard work:show -->", work.get('work_id')
    API.filterByWork work

  App.vent.on "category:show", (filter) ->
    # places for all passages in works of a category
    API.filterByCategory filter

  App.vent.on "place:focus", (area) ->
    # console.log 'map_app place:focus', area
    API.focusPlace(area)

  App.vent.on "map:swap", (id) ->
    MapApp.Show.Controller.swapBase id

  App.vent.on "search:show", (filter) ->
    # places for all passages returned by search
    API.filterByPassages filter

  API =
    # swapBase: (id) ->
    #   MapApp.Show.Controller.swapBase()

    showMap: ->
      MapApp.Show.Controller.showMap()

    filterByPassages: (passageids) ->
      # console.log "passageids", passageids
      MapApp.Show.Controller.filterPlaces({passages: passageids, clear:true})

    filterByAuthors: (authids) ->
      MapApp.Show.Controller.filterPlaces({author_id: authids, clear:true})

    renderOneAuthor: (params) ->
      # console.log 'API.renderOneAuthor', params
      MapApp.Show.Controller.renderOneAuthor(params)

    dropOneAuthor: (params) ->
      # console.log 'API.dropOneAuthor', params
      MapApp.Show.Controller.dropOneAuthor(params)

    filterByCategory: (filter) ->
      MapApp.Show.Controller.filterPlaces(filter)

    filterByWork: (work) ->
      id = work.get("work_id")
      # MapApp.Show.Controller.setFilter 'work', (placeref) ->
      #   placeref.get("work_id") == id
      MapApp.Show.Controller.filterPlaces({work_id: id, clear:true})

    focusPlace: (area) ->
      #
      # area model in list has been clicked, need to
      # 1) zoom to its voronoi extents
      # 2) get resulting viewport extents\
      # 3) filter placerefs for viewport w/o filtering map
      #
      window.area = area
      window.hbounds = turf.polygon(wellknown(area.get("geom_poly_wkt")).coordinates)
      # console.log 'hbounds from this:', wellknown(area.get("geom_poly_wkt")).coordinates

      MapApp.Show.Controller.zoomTo 'area', area

      # TODO: filter for places/placerefs within area
      # MapApp.Show.Controller.filterByArea "area", hbounds

    resetMap: (state)->
      # TODO: where am I when this is run? clean up accordingly
      # console.log 'resetMap() called from:', state
      $("#place_passages_region").fadeOut("slow")
      MapApp.Show.Controller.resetMap()

    clearAuthors: ->
      MapApp.Show.Controller.clearAuthors()

  # TODO: part of refactoring for areas - single area:show

  App.vent.on "map:reset", (state) ->
    API.resetMap(state)

  App.vent.on "map:clearauthors", ->
    API.clearAuthors()

  App.vent.on "placeref:click", (prid) ->
    # console.log 'map_app heard highlight id#', iid
    MapApp.Show.Controller.onClickPlaceref prid

  App.vent.on "placeref:highlight", (prid) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature prid

  App.vent.on "placeref:unhighlight", (prid) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature prid

  App.vent.on "area:highlight", (id) ->
    # console.log 'map_app heard highlight id#', id
    MapApp.Show.Controller.onHighlightFeature 'area', id

  App.vent.on "area:unhighlight", (id) ->
    # console.log 'map_app heard unhighlight, id#', id
    MapApp.Show.Controller.onUnhighlightFeature 'area', id

  App.vent.on "area:unhighlightAll", ->
    MapApp.Show.Controller.unhighlightAll()


  MapApp.on "start", ->
    controller: API
    API.showMap()
