@AL.module "WorksApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "works/show/templates/show_layout"
    # template: "works/show/templates/show_work"
    regions:
      titleRegion: "#title_region"
      navRegion: "#nav_region"
      workContentRegion: "#work_content_region_w"

  class Show.Title extends App.Views.ItemView
    template: "works/show/templates/_title"
    events:
      "click .crumb-works": "goHome"

    goHome: ->
      # console.log 'supposed to go home'
      AL.WorksApp.List.Controller.startWorks()
      Backbone.history.navigate("works")
      # Backbone.history.navigate("works", true)
      App.vent.trigger("map:reset")

  class Show.Nav extends App.Views.ItemView
    template: "works/show/templates/_nav"

  class Show.Passage extends App.Views.ItemView
    template: "works/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.placeref": "onPlacerefEnter"
      "mouseleave span.placeref": "onPlacerefLeave"
    }
    # highlightPlacerefs: ->
    #   console.log 'Show.Passage.highlightPlacerefs()'

    onPlacerefClick: (e) ->
      # window.context = $(e.currentTarget).context
      prid = $(e.currentTarget).context.attributes.val.value
      # workid = App.request("work:model").get("work_id")
      App.vent.trigger 'placeref:click', {'id': prid}

      # takes a params object now
      # App.vent.trigger('placeref:click', prid)

    onPlacerefEnter: (e) ->
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefEnter', prid
      # App.vent.trigger('placeref:highlight', prid);

    onPlacerefLeave: (e) ->
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefLeave', id
      # App.vent.trigger('placeref:unhighlight', prid);

    getPlacerefIdFromEvent: (e) ->
      Number($(e.currentTarget).context.attributes.data_id.value);

  # passages are shown by clicking a work
  class Show.Passages extends App.Views.CompositeView
    template: "works/show/templates/_passages"
    childView: Show.Passage
    childViewContainer: "div"

  class Show.Work extends App.Views.ItemView
    template: "works/show/templates/_work"
    tagName: "li"
    events: {"click": "loadPassages"}
    loadPassages: ->
      work = this.model
      # show tab CHECK: leave visible?
      $("#passages_pill").removeClass("hidden")
      $(".nav-pills li").removeClass("active")
      $("#passages_pill").addClass("active")
      # use route for model attributes and navigation
      Backbone.history.navigate("workpassages/w/"+work.get('work_id'))

  class Show.Works extends App.Views.CompositeView
    template: "works/show/templates/_works"
    className: 'works'
    childView: Show.Work
    childViewContainer: "ul"
