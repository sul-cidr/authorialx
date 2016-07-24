@AL.module 'PlacesApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startPlaces: (borough)->
      # console.log 'startPlaces', borough
      # get, render places content
      @layout = @getLayoutView()

      @layout.on "show", =>
        $("#spin_authors").addClass('hidden')
        # AL.ContentApp.Show.Controller.showTab('places')
        @showSearchbox()
        # comment if no navmap
        @showNavmap(borough)
        # if areas haven't loaded, pause
        if window.location.href.substr(-7) == "#places" && typeof activeAreas == "undefined"
          # console.log 'pausing'
          setTimeout (->
            AL.PlacesApp.List.Controller.listAreas(borough)
          ), 4500
        else
          @listAreas(borough)

      App.placesRegion.show @layout

    listAreas: (borough) ->
      $("#places_navmap h4").html('Neighborhoods in and around <span class="red">'+
        boroughHash[borough]+'</span')
      hoodArray = boroughHoods[borough]

      # console.log 'url in listAreas', window.location.href

      window.areas = App.reqres.getHandler("areas:active")()
      window.filteredAreas = areas.filter((area) ->
        area.get('area_id') in hoodArray
      )
      # new collection from models
      boroughCollection = new Backbone.Collection(filteredAreas);
      # view with collection
      areasView = @getAreasView boroughCollection
      # console.log 'boroughCollection ', boroughCollection
      @layout.arealistRegion.show areasView
      App.reqres.setHandler "borough:current", ->
        return borough

    getAreasView: (boroughCollection) ->
      new List.Areas
        collection: boroughCollection
        filter: (child, index, collection) ->
          child.get('area_type') == 'hood'

    getLayoutView: ->
      new List.Layout

    showSearchbox: ->
      # App.request "placeref:entities", {}, (placerefs) =>
      # console.log 'showSearchbox', placerefs
      searchboxView = new List.Searchbox
        # collection: placerefs
      @layout.searchboxRegion.show searchboxView

    showNavmap: (borough)->
      navmapView = new List.Navmap
      # console.log navmapView
      @layout.navmapRegion.show navmapView
      # put map in div with borough selected
      $("#keymap").html( makeKeymap(borough) )
