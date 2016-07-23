@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showPlaceref: (prid) ->
      #   display passage(s) for related Place in right panel
      #   zoom to and center on Place
      #   LEFT PANEL: navigate to relevant borough? hood? possible?
      #
      # console.log 'showPlaceref(prid)', prid
      # zoom to the place
      App.vent.trigger('placeref:click', {id: prid})
      # get place_id
      App.request "placeref:entities", {id: prid}, (placerefs) =>
        $("#spin_district").removeClass('hidden')
        pid = placerefs.models[0].attributes.placeref.place_id
        # console.log 'placerefs', placerefs
        # console.log 'with place_id', pid
        App.request "area:place", pid, (parent) =>
          aid = parent.models[0].attributes.area_id
          # console.log 'parent area', aid
          Backbone.history.navigate("places/"+aid, true)
          $("#spin_district").addClass('hidden')

    showPlace: (id) ->
      # console.log 'showPlace(id)', id

      App.request "area:entity", id, (area) =>
        # get placerefs within area
        App.request "placeref:entities", {area_id:id}, (activePlacerefs) =>
          window.activeplacerefs = activePlacerefs
          @showPlaceSummary activePlacerefs
        @placeLayout = @getPlaceLayout area
        @placeLayout.on "show", =>
          # console.log 'areaLayout shown'
          @showTitle area
          @showPlaceContent area

          ga('send', 'pageview', area.get("prefname"));

          # for map
          App.vent.trigger "place:focus", area

          # CHECK: expose current area model here?
          App.reqres.setHandler "area:model", ->
            return area
      # keep showing in the placesRegion for now; areas are one kind of place
      App.placesRegion.show @placeLayout

    showPlaceSummary: (activePlacerefs) ->
      # console.log 'showPlaceSummary() activePlacerefs', activePlacerefs
      @activePlacerefs = activePlacerefs
      window.wPlacerefs = []
      window.worksYears = []
      @bPlacerefs = []
      _.each activePlacerefs.models, (p) =>
        # console.log 'activePlacerefs', p
        wPlacerefs.push(p.attributes.placeref)
        worksYears.push(p.attributes.work.work_year)

      crossworks = crossfilter(wPlacerefs)
      crossbio = crossfilter(@bPlacerefs)
      # console.log 'have crossworks and crossbio array'

      authById = crossworks.dimension (d) ->
        d.author_id
      window.placerefsByAuthor = authById.group((author_id) ->
        author_id).all()

      # render histogram and bubble vis
      $("#place_content_region").html(@makeVis placerefsByAuthor, worksYears)

    makeVis: (auths, years) ->
      # console.log years
      window.authobj = {"children":[]}
      # console.log authobj
      _.each auths, (a) =>
        authobj['children'].push(a)
      # in vis.js
      histYears(years)
      packAuths(authobj)

    getPlaceLayout: (area) ->
      new Show.Layout ({
        model: area
      })

    showTitle: (area) ->
      # console.log 'in showTitle', area.get("name")
      titleView = @getTitleView area
      @placeLayout.titleRegion.show titleView

    getTitleView: (area) ->
      new Show.Title
        model: area

    # renders template with area keywords field
    showPlaceContent: (area) ->
      # console.log 'showPlaceContent', area
      @contentView = @getContentView area
      @placeLayout.placeContentRegion.show @contentView

    getContentView: (area) ->
      new Show.Content
        model: area

    listPlacePassages: (authid) ->
      # console.log 'listPlacePassages() for', authid
      $("#place_passages_region").removeClass("hidden")
      prefname = authHash[authid].fullname

      window.authorPlacerefs =
        _.filter @activePlacerefs.models, (pr) =>
          pr.attributes.placeref.author_id == authid

      # get passage_ids for author
      window.passage_ids = []
      _.each authorPlacerefs, (p) =>
        # console.log 'p',p
        passage_ids.push p.attributes.placeref.passage_id

      # retrieve single author's passages for an area
      App.request "passages:place", passage_ids, (place_passages) =>
        # if App.authorContentRegion.$el.length > 0
        #   App.authorContentRegion.reset()
        window.placepassages = place_passages
        placePassagesView = @getPlacePassagesView place_passages

        App.placePassagesRegion.show placePassagesView
        $("#place_passages_region").removeClass('hidden')
        # App.placePassagesRegion.$el.fadeIn("slow")
        #
        $(".passages-places h4").html(authHash[authid])

    getPlacePassagesView: (place_passages) ->
      new Show.PlacePassages ({
        collection: place_passages
        viewComparator: "passage_id"
        className: 'passages-places'
      })

    # generates summary by author
    # TODO: by decade
