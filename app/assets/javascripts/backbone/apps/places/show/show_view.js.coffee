@AL.module "PlacesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "places/show/templates/show_layout"
    regions:
      titleRegion: "#place_title_region"
      navRegion: "#place_nav_region"
      placeContentRegion: "#place_content_region"
    events:
      "click .red": "recenter"

    recenter: (e) ->
      # hood = Number($(e.currentTarget).context.attributes.val.value)
      hood = App.request "area:model"
      geom = hood.attributes.geom_point_wkt
      map.setView(swap(wellknown(geom).coordinates))
      # console.log 'recentered to', hood

  class Show.Title extends App.Views.ItemView
    template: "places/show/templates/_title"
    events:
      "click .crumb-places": "goHome"

    goHome: ->
      # console.log 'goHome() navigates to /places'
      # reset url, b/c it may have changed via a search
      App.vent.trigger("map:reset", "places_show")
      borough = App.request "borough:current"
      console.log 'go home to borough', borough
      Backbone.history.navigate("places", true)
      # AL.PlacesApp.List.Controller.startPlaces(borough)

  class Show.PlacePassage extends App.Views.ItemView
    template: "places/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.placeref": "onPlacerefEnter"
      "mouseleave span.placeref": "onPlacerefLeave"
    }

    onPlacerefClick: (e) ->
      # window.context = $(e.currentTarget).context
      prid = this.getPlacerefIdFromEvent(e);
      # prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'clicked placeref', prid
      App.vent.trigger('placeref:click', {id: prid} )

    onPlacerefEnter: (e) ->
      prid = this.getPlacerefIdFromEvent(e);
      # console.log 'highlight placeref #', prid
      # App.vent.trigger('placeref:highlight', prid);
      # App.vent.trigger('placeref:hover', e)

    onPlacerefLeave: (e) ->
      prid = this.getPlacerefIdFromEvent(e);
      # console.log 'left placeref span'
      # App.vent.trigger('placeref:unhighlight', prid);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.val.value);

  class Show.PlacePassages extends App.Views.CompositeView
    template: "places/show/templates/_passages"
    childView: Show.PlacePassage
    childViewContainer: "placepassages"
    events: {
      "click #passage_closer": "closeRightPanel"
    }

    closeRightPanel: ->
      App.placePassagesRegion.$el.addClass('hidden')
      map.closePopup()

  class Show.Content extends App.Views.ItemView
    template: "places/show/templates/_content"
