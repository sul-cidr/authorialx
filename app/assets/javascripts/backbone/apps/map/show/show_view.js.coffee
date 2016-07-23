@AL.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Map extends Marionette.ItemView
    template: "map/show/templates/show_map"
    events: {
      "click .passage-link": "showOnePassage"
      "click .author-link": "goToAuthor"
      "click body": "closeAbout"
    }
    closeAbout: ->
      HeaderApp.Show.Controller.loadAbout()

    goToAuthor: (e) ->
      id = $(e.currentTarget).context.attributes.val.value
      Backbone.history.navigate("authors/" + id, true)

    showOnePassage: (e) ->
      # console.log 'popup passage', $(e.currentTarget).context.attributes.val.value
      id = $(e.currentTarget).context.attributes.val.value
      # TODO: load passage in right panel
      Show.Controller.showOnePassage(id)

    closePassage: ->
      $(App.placePassagesRegion.$el).addClass("hidden")
      # App.placePassagesRegion.$el.hide()

    initialize: ->
      @filters = {}
      @filteredFeatures = []
      @keyPlaces = {}
      @numPlaces = 0
      window.placesCount = 820
      @legendColors = [0,1,2]
      window.colors = @legendColors
      @filteredAuthors = []
      # console.log 'filteredFeatures: ', @filteredFeatures

    swapBase: (id) ->
      # London = [51.5120, -0.0928]
      # TODO "eval is evil"
      # what is active lyr id?
      active = $("#map_chooser li.active").attr("val")
      # console.log 'swapBase(id): active, new: '+ active, id
      # clear all tabs of active class
      $("#map_chooser li").removeClass('active')
      # make selected active
      $("#map_chooser li[val='"+id+"']").addClass('active')
      lyr = eval(id)
      # console.log 'eval(id):', lyr
      # if the active map was historic, remove it
      if active != 'l_osm'
        # console.log 'active was != l_osm, it was ', active
        map.removeLayer(eval(active))
      if id == 'l_indicator'
        if map.getZoom() < 13
          map.setView(@London, 13)
        map.addLayer(lyr)
      # if id == 'l_bowles_wms'
      if id == 'l_bowles'
        if map.getZoom() < 14
          map.setView(@London, 14)
        map.addLayer(lyr)
      if id == 'l_taylor'
        if map.getZoom() < 15
          map.setView(@London, 15)
        map.addLayer(lyr)

    zoomTo: (what, geom) ->
      if what == "area"
        # geom is an area model; zoom to its voronoi extents
        # console.log 'zoomTo geom:', geom
        marker = $idToFeature.areas[geom.get("area_id")];
        mbounds = marker.getBounds()
        map.fitBounds(mbounds)
      window.mbounds = mbounds
      # get the bounds of the resulting viewport
      window.vbounds = turf.polygon([createPolygonFromBounds( map.getBounds() )])

    # pre-initMap
    onDomRefresh: ->
      @initMap()

      App.request "area:entities", (areas) =>
        # console.log areas
        window.activeAreas = areas
        @ingestAreas areas
        # make available to places_app
        App.reqres.setHandler "areas:active", ->
          return activeAreas

        @renderPlaces({clear:true})

    initMap: ->
      # console.log 'initMap'
      @map = L.map('map', {
        zoomControl: false,
        attributionControl: false,
        fadeAnimation: true,
        maxZoom: 18,
        inertiaMaxSpeed: 1000
      }).setActiveArea('viewport-authors')

      baseMaps = {
        "Modern": l_mblight
        # "Modern": l_osm
      }
      overlayMaps = {
        "Indicator (1880)":l_indicator
        # "Bowles (1783)":l_bowles_wms,
        "Bowles (1783)":l_bowles,
        "Taylor (1723)":l_taylor
      }

      # L.control.layers(baseMaps,overlayMaps).addTo(@map);

      # Zoom buttons on top right.
      zoomControl = L.control.zoom({
        position: 'topright'
      });

      @map.addControl(zoomControl);

      @London = [51.5094, -0.1212]
      # @NewYork = [40.730610, -73.935242]
      # @Copenhagen = [55.676098, 12.568337]

      # use if not mapbox
      # @map.addLayer(l_osm);

      @map.addLayer(l_mblight);

      @map.setView(@London, 12)
      # @map.setView(@NewYork, 12)
      # @map.setView(@Copenhagen, 12)

      @map.addEventListener 'popupclose', ( (e) =>
        e.preventDefault
        $("#place_passages_region").addClass('hidden')
        # activeMarker.setIcon(houseMarker)
        return
      ), this

    $idToFeature = {areas:{}, places:{}, images:{}}
    window.idToFeature = $idToFeature

    removePlaces: (params) ->
      # window.colors = @legendColors
      places = @keyPlaces[params['key']]
      # drop marker set from map
      map.removeLayer(places.markers)

      # add color back to available array
      @legendColors.push(places.color)
      console.log 'legendColors after restore', @legendColors

      # remove legend <li>
      $("#leg_"+params['author_id']).remove()
      # delete from hash
      delete @keyPlaces[params['key']]
      # if no authors are checked any more, render all
      if params['count'] == 0
        $("#legend_compare").addClass('hidden')
        $("#legend_base").removeClass('hidden')
        # are we in a filtered state?
        # if so, restore filter
        if $("#selected_cat_authors").html() == ""
          @renderPlaces({clear:true})
        else
          # console.clear()
          # console.log 'need to restore filter for', @filteredAuthors
          @renderPlaces({clear:true, author_id:@filteredAuthors})

    clearKeyPlaces: ->
      # called by map:reset --> resetMap()
      @keyPlaces = {}
      @legendColors = [0,1,2]

    clearAuthors: ->
      # console.log 'clearAuthors()'
      # called by map:reset --> resetMap()
      @keyPlaces = {}
      @legendColors = [0,1,2]
      @authlabel=''
      $("#legend_list li").remove()

    getColors: (prtype, legend=false, mincolor)->
      # console.log prtype, legend, mincolor
      markerColors = {
        0: {0:"yellow",1:"orange",2:"red"},
        1: {0:"#fde0dd", 1:"#fa9fb5", 2:"#c51b8a"}, # purples
        2: {0:"#c2e699", 1:"#78c679", 2:"#238443"}, # greens
        # 1: {0:"#ece7f2",1:"#a6bddb",2:"#2b8cbe"} # blues
        # 2: {0:"#e5f5e0",1:"#a1d99b",2:"#31a354"} # greens
      }

      if prtype == 'work'
        return markerColors[mincolor][2]
      else if prtype == 'bio'
        return markerColors[mincolor][0]
      else
        return markerColors[mincolor][1]

    # return tag for symbolizing places by placeref_type distrib
    prType: (count, biocount)->
      # console.log 'count, biocount', count, biocount
      if biocount == null
        return 'work'
      else if count == biocount
        return 'bio'
      else
        return 'both'

    buildPopup: (params) ->
      # console.log 'buildPopup() params', params
      html = ''

      App.request "placeref:entities", params, (placerefs) =>
        # console.log 'params', params
        # console.log 'placerefs models', placerefs.models
        _.each placerefs.models, (pr) =>
          # console.log 'placeref attributes', pr.attributes
          if pr.attributes.placeref.placeref_type == 'work'
            html += '<b>'+pr.attributes.placeref.placeref +
              '</b>, in <em>' +
              pr.attributes.work.title + '</em><br/>('+
              pr.attributes.author.prefname +
              '; '+pr.attributes.work.work_year+
              ')&nbsp;[<span class="passage-link" val='+
              pr.attributes.placeref.passage_id+'>passage</span>]<hr/>'
          else
            html += '&#8220;'+pr.attributes.placeref.placeref +
              ',&#8221; a place in the life of ' +
              '<span class="author-link" val='+
              pr.attributes.placeref.author_id+'>'+
              pr.attributes.author.prefname+'</span><hr/>'

        idToFeature.places[params['place_id']].bindPopup(html)
          .on("popupclose", ->
            if $("#image_modal").html() != ""
              $("#image_modal").dialog("close")
            )
        idToFeature.places[params['place_id']].openPopup()

    renderPlaces: (params) ->
      # params: author_id=[], work_id=[], clear=[true|false]
      # console.log 'renderPlaces', params
      if typeof @places != "undefined"
        if params && params['clear'] == true
          if typeof(@keyPlaces) != "undefined" && Object.keys(@keyPlaces).length > 0
            # console.log '@keyPlaces',Object.keys(@keyPlaces).length, @keyPlaces
            $.each @keyPlaces, (k,v) ->
              # console.log 'removing', v.markers._leaflet_id
              map.removeLayer(map._layers[v.markers._leaflet_id])
          @places.clearLayers()
          @clearAuthors()
          # @map.setView(@London, 12)
      if params && params['author_id'] && !($.isArray(params['author_id']))
        App.request "author:entity", params['author_id'], (author) =>
          @authlabel = author.get("label")
          console.log 'authlabel', @authlabel
      App.request "place:entities", params, (places) =>
        @numPlaces = places.models.length
        window.numPlaces = @numPlaces
        App.reqres.setHandler "places:count", ->
          return @numPlaces

        @features = []
        max = Math.max.apply(Math, places.map((o) ->
          o.attributes.count ))
        if params['author_id'] && @keyPlaces['auth_'+params['author_id']]
          @mincolor = 0
        else
          @mincolor = Math.min.apply(Math, @legendColors)
        # console.log 'color set from @mincolor was', @mincolor
        $.each places.models, (i, pl) =>
          # TODO: get max of count()
          attribs = pl.attributes.place
          prcount = pl.attributes.count # placerefs-per-place
          prtype = @prType(prcount, pl.attributes.biocount) # return work, bio, both
          geom = attribs.geom_wkt
          pid = attribs.place_id
          pname = attribs.prefname
          if geom.substr(0,5) == 'POINT'
            coords = swap(wellknown(geom).coordinates)
            l_geom = new L.LatLng(coords[0],coords[1])

            feature = new L.CircleMarker(l_geom, {
              color: '#000',
              fillColor: @getColors(prtype,false,@mincolor),
              radius: scaleMarker(prcount,[1,max]),
              fillOpacity: 0.5,
              weight: 1
            })

          else if geom.substr(0,10) == 'LINESTRING'
            feature =  new L.GeoJSON(wellknown(geom), {
              style: mapStyles.street
            })

          else if geom.substr(0,10) == 'MULTIPOINT'
            feature =  new L.GeoJSON(wellknown(geom), {
              style: mapStyles.multipont
            })

          # got a feature, whatever its geometry
          feature.on('click', () ->
            ga('send', 'event', "select", "place", pname)
            # TODO: why is this necessary?
            # window.location.hash = '#'
            html = ''
            @filter = params
            # add this placeid
            @filter['place_id'] = pid
            # add author or work as appropriate
            if params['author_id']
              @filter['author_id'] = params['author_id']
            else if params['work_id']
              @filter['work_id'] = params['work_id']
            # console.log '@filter (params +)', @filter
            App.MapApp.Show.Controller.buildPopup @filter
          )

          @popup = feature.bindPopup(
            pname, {
              'className': 'place-popup',
              'maxHeight': '300'}
            ).on('popupclose', (e) ->
            if $("#imagelist").length > 0
              $("#imagelist .image img").removeClass('photo-pop')
            )

          # add model, id to feature
          feature.model = pl
          feature.options.id = pid
          # feature._leaflet_id = pid
          $idToFeature.places[pid] = feature
          @features.push feature

        @places = L.featureGroup(@features)

        # if there's an author_id, add this set to hash
        # if not, render all
        if params['author_id']
          if !($.isArray(params['author_id']))
            @key = if params['key'] then params['key'] else 'auth_'+params['author_id']
            # console.log 'key', @key
            # console.log '@legendColors', @legendColors
            @keyPlaces[@key] = {}
            @keyPlaces[@key]['markers'] = @places
            @keyPlaces[@key]['color'] = Math.min.apply(Math,@legendColors);
            window.keyplaces = @keyPlaces
            # remove this color set from available
            idx=@legendColors.indexOf(@keyPlaces[@key].color)
            @legendColors.splice(idx,1)
            # console.log '@legendColors now', @legendColors
          else
            # this is a filtered array of authors
            _.each params['author_id'], (a) =>
              if @filteredAuthors.indexOf(a) < 0
                @filteredAuthors.push a
            # console.log '@filteredAuthors', @filteredAuthors

        # populate legend
        # console.log 'authlabel', @authlabel
        if Object.keys(@keyPlaces).length > 0
          if $("#leg_"+params['author_id']).length == 0
            @makeLegend(params['author_id'], @mincolor)

        # TODO: stop using hardcoded total
        if @numPlaces < 820
          @map.fitBounds(@places.getBounds())
        else
          @map.setView(@London, 12)

        @places.addTo(@map)
        # @mapImages(params)
        # TODO: stop exposing these
        window.places = @places
        window.features = @features

    makeLegend: (authid, mincolor)->
      $("#legend_list").append('<li id=leg_'+authid+'>'+
        '<svg width="96" height="20">
          <circle cx="8" cy="12" r="6" fill="'+@getColors('work',true,mincolor)+'"/>'+'
          <circle cx="48" cy="12" r="6" fill="'+@getColors('bio',true,mincolor)+'"/>'+'
          <circle cx="84" cy="12" r="6" fill="'+@getColors('both',true,mincolor)+'"/>'+'
        </svg><span class="auth-label">'+@authlabel+'</span></li>'
        )
      $("#legend_base").addClass('hidden')
      $("#legend_compare").removeClass('hidden')

    # neighborhood voronoi polygons (not visible)
    ingestAreas: (areas) ->
      @areaFeatures = []
      $.each areas.models, (i, a) =>
        geom = a.attributes.geom_poly_wkt
        aid = a.get("area_id")
        # they're all hoods, but leaves possibility for hierarchy
        if a.get("area_type") == "hood"
          # console.log geom
          feature =  new L.GeoJSON(wellknown(geom), {
            style: mapStyles.area.start
          })

          # model-to-map feature hash
          $idToFeature.areas[aid] = feature
          @areaFeatures.push feature

      @areas = L.featureGroup(@areaFeatures)

      @areas.addTo(@map)
      # TODO: stop exposing these
      window.map = @map
      window.leaf_areas = @areas
      window.areaFeatures = @areaFeatures

    # onclick placeref in text
    # called by Show.Controller on trigger 'placeref:click'
    clickPlaceref: (params) ->
      # console.log 'clickPlaceref params', params
      $("#imagelist .image img[prid="+params['id']+"]").addClass('photo-pop')
      App.request "placeref:entities", params, (placerefs) =>
        # console.log 'placeref models', placerefs
        if placerefs.models.length == 0
          # just showing image
          $(".ui-dialog-titlebar").prepend('<span id="unmapped_tag">(not georeferenced yet)</span>')
        else
          @placeid = placerefs.models[0].attributes.placeref.place_id
          # identify marker and zoom to its latlng
          @marker = $idToFeature.places[@placeid]
          if @marker._latlng != undefined
            # it's a point
            latlng = @marker._latlng
            # console.log latlng
          else
            # it's a linestring, zoom to its centroid
            latlng = @marker.getBounds().getCenter()
          # console.log latlng
          App.MapApp.Show.Controller.buildPopup({
            'place_id': @placeid
            'author_id': params['author_id']
          })
          map.setView(latlng,15)
          # map.setView(latlng,15,{animate:true})

    # triggered from passages, area list
    highlightFeature: (prid) ->
      window.wid = App.reqres.getHandler('activework:id')()
      # if what == "placeref"
      marker = $idToFeature.placerefs[prid];
      # if it's a point in cluster, remove it and re-place on map:
      if marker._latlng != undefined
        # console.log 'highlightFeature marker pre ',marker
        @markerClusters.removeLayer(marker)
        map.addLayer(marker)
        # make it bigger
        marker.setIcon(houseMarkerM)
        # console.log 'highlightFeature marker ',marker
        window.activeMarker = marker
      else
        # console.log 'a linestring', marker

    unhighlightFeature: (prid) ->
      marker = $idToFeature.placerefs[prid];
      # console.log 'what, id, marker: '+ what, id, marker
      if what == "placeref"
        marker.setIcon(houseMarker)
        # TODO: maybe put in back in a cluster?

    unhighlightAll: ->
      # console.log 'unhighlightAll()', @areas
      @areas.setStyle(mapStyles.area.start)

    onSelectFeature: (e) ->
      # App.vent.trigger('placeref:select', e.layer.options.id);
      e.layer.openPopup()

    onUnselectFeature: (e) ->
      # App.vent.trigger('placeref:select', e.layer.options.id);
      e.layer.closePopup()

    selectFeature: (what, id) ->
      marker = $idToFeature.placerefs[id];
      this.map.flyTo(marker.getLatLng(), styles.zoom.feature);

    # L.mapbox.accessToken = 'pk.eyJ1IjoiZWxpamFobWVla3MiLCJhIjoiY2loanVmcGljMG50ZXY1a2xqdGV3YjRkZyJ9.tZqY_fRD2pQ1a0E599nKqg'

    # mapbox light basemap, in progress
    l_mblight = L.mapbox.tileLayer(
        # 'elijahmeeks.8a9e3cb1', # light
        'elijahmeeks.e72a8419',  # emerald
        L.mapbox.accessToken, {
        attribution: 'Mapbox',
        detectRetina: true
        });

    # OSM base layer
    l_osm = L.tileLayer(
      'http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png',
      { detectRetina: true }
      );

    l_indicator = L.mapbox.tileLayer(
        'elijahmeeks.5s7vzgi4',
        # 'elijahmeeks.gqd89536',
        L.mapbox.accessToken, {
        attribution: 'Indicator (1880)',
        detectRetina: true
        });

    l_bowles = L.mapbox.tileLayer(
        'elijahmeeks.95vtr2c4',
        # 'elijahmeeks.36cac3di',
        L.mapbox.accessToken, {
        attribution: 'Bowles (1783)',
        detectRetina: true
        });

    # l_bowles = L.tileLayer.wms('http://hgl.harvard.edu:8080/geoserver/wms/', {
    #   layers: 'cite:SDE2.G5754_L7_1783_B6',
    #   format: 'image/png',
    #   transparent: true
    # })

    l_taylor = L.mapbox.tileLayer(
        'elijahmeeks.1pr88bpk',
        # 'elijahmeeks.7dd6ynaj',
        L.mapbox.accessToken, {
        attribution: 'Taylor (1723)',
        detectRetina: true
        });
