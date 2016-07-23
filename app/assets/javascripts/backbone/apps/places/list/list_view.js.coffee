@AL.module "PlacesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "places/list/templates/list_layout"

    regions:
      searchboxRegion: "#searchbox_region"
      navmapRegion: "#navmap_region"
      arealistRegion: "#arealist_region"

  class List.Navmap extends App.Views.ItemView
    template: "places/list/templates/_navmap"


  class List.Area extends App.Views.ItemView
    template: "places/list/templates/_area"
    tagName: "span"
    events: {
      "click a": "areaByRoute"
      "mouseenter a": "onAreaEnter"
      "mouseleave a": "onAreaLeave"
    }

    areaByRoute: ->
      window.activePlace = this.model
      area = this.model
      id = area.get('area_id')
      @route = "places/" + id
      # console.log 'areaByRoute(): ',@route

      Backbone.history.navigate(@route, true)
      # runs AL.PlacesApp.Show.Controller.showPlace(id)

    onAreaEnter: (e) ->
      id = this.getAreaIdFromEvent(e);
      # console.log 'mouseover area #', id
      # App.vent.trigger('area:highlight', id);

    onAreaLeave: (e) ->
      id = this.getAreaIdFromEvent(e);
      # console.log 'left area a'
      # App.vent.trigger('area:unhighlight', id);

    getAreaIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  class List.Areas extends App.Views.CompositeView
    template: "places/list/templates/_areas"
    childView: List.Area
    emptyView: List.Empty
    childViewContainer: "arealist"


  class List.Searchbox extends App.Views.ItemView
    template: "places/list/templates/_searchbox"
    events: {
        "focus #search_input": "getAutocomplete"
        # "click button": "showPlace"
    }

    getAutocomplete: ->
      choice = $('#search_place_chooser input:radio:checked').val()
      # console.log 'getAutocomplete', choice
      if choice == 'hoods'
        $("#search_input").autocomplete({
          source: areaLookup
          select: (event, ui) ->
              event.preventDefault()
              @selectedArea = ui.item.value
              $("#search_input").val(ui.item.label)
              @route = "places/" + @selectedArea
              # console.log 'autocomplete route,', @route
              Backbone.history.navigate(@route, true)

          focus: (event, ui) ->
              event.preventDefault()
              $("#search_input").val(ui.item.label)
        })
      else if choice == 'all'
        $("#search_input").autocomplete({
          focus: (event, ui) ->
              event.preventDefault()
              $("#search_input").val(ui.item.label)
          source: placerefLookup
          select: (event, ui) ->
            event.preventDefault()
            @selected = ui.item.value
            $("#search_input").val(ui.item.label)
            console.log 'ui.item.label', ui.item.label

            # TODO: make hoodList array dynamic
            # build route for area or placeref
            if hoodList.indexOf(ui.item.label) > 0
              # TODO: make areaLookup dynamic
              # it's a neighborhood, do the usual for that
              aid = $.grep(areaLookup, (e) ->
                return e.label == ui.item.label; )
              @route = "places/" + aid[0].value
              # console.log 'that\'s a neighborhood'
              Backbone.history.navigate(@route, true)
            else
              @route = "placerefs/" + @selected
            # console.log 'autocomplete route,', @route
            Backbone.history.navigate(@route, true)
        })

  class List.Empty extends App.Views.ItemView
    template: "places/list/templates/_empty"
    tagName: "p"
