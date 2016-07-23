@AL.module "AuthorsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "authors/show/templates/show_layout"
    # template: "authors/show/templates/show_author"
    regions:
      titleRegion: "#title_region"
      navRegion: "#nav_region"
      authorContentRegion: "#author_content_region"

  class Show.Image extends App.Views.ItemView
    template: "authors/show/templates/_image"
    # wrapping element necessary; 'div' used if omitted
    tagName: "span"
    events: {
      'click img': 'popImage'
    }

    popImage: ->
      if $("#image_modal").hasClass('ui-dialog-content')
        $("#image_modal").dialog("close")
      $("#unmapped_tag").remove()
      prid = this.model.get('placeref_id')
      iid = this.model.get('id')
      label = this.model.get('label')
      fn = "assets/images/mapped/full/" + this.model.get('filename')
      # console.log 'img:',iid,prid,label,fn
      # send id to create map popup
      App.vent.trigger 'placeref:click', {'id': prid}
      # photo border
      $("#imagelist .image img[iid="+iid+"]").addClass('photo-pop')
      # load image
      $("#image_modal").html("<img src='"+fn+"' style='width:300px;'/>")
      # open dialog
      # $(".ui-dialog-titlebar").prepend('<p>(not georeferenced yet)</p>')
      @imgDialog = $("#image_modal").dialog(
        {
          modal: false,
          title: label,
          show: { effect: "fadeIn", duration: 500 },
          # position: { my: "left+370 bottom-120", at: "left bottom", of: window},
          close: (event, ui) ->
            map.closePopup()
            $("#imagelist .image img").removeClass('photo-pop');
        })
      # TODO: position needs calculation after image is loaded?
      @imgDialog.dialog('option', 'position',  { my: "left+370 top+70", at: "left top", of: window})

  class Show.ImageList extends App.Views.CompositeView
    template: "authors/show/templates/_images"
    childView: Show.Image
    emptyView: Show.Empty

    # childViewContainer: "#links"
    childViewContainer: "div"

  class Show.Title extends App.Views.ItemView
    template: "authors/show/templates/_title"
    events:
      "click #crumb_authors": "goHome"
      "click #crumb_author": "goAuthor"

    goHome: ->
      # restore dimensions dropdowns
      $("#dimensions_region").removeClass("hidden")
      # execute startAuthors()
      Backbone.history.navigate("authors", true)
      App.vent.trigger("map:reset", "authors_show")
    goAuthor: (e) ->
      # window.location.hash
      # console.log $(e.currentTarget).context.attributes
      id = $(e.currentTarget).context.attributes.val.value
      Backbone.history.navigate("authors/"+id, true)

  class Show.Pills extends App.Views.ItemView
    template: "authors/show/templates/_nav"
    events: {
      "click li": "loadContent"
    }
    loadContent: (e) =>
      $(".nav-pills li").removeClass("active")
      $(e.currentTarget).addClass("active")
      authid = App.request("author:model").get("author_id")
      @pill = $(e.currentTarget).context.attributes.value.value
      if @pill == 'works'
        $("#passages_pill").addClass("hidden")
        if $("#crumb_works").length < 1
          $("#author_crumbs").append('<span id="crumb_works" class="crumb-left"> :: Works </span>')
        $("#crumb_author").addClass("crumb-link")
        @route = "works/"+authid
        # console.log 'loadContent, works:', @route
        Backbone.history.navigate(@route, true)
        # Show.Controller.listWorks authid
      else if @pill == 'biography'
        @route = "authors/"+authid
        # executes Show.Controller.showAuthor
        Backbone.history.navigate(@route, true)

  class Show.Passage extends App.Views.ItemView
    template: "authors/show/templates/_passage"
    tagName: "p"
    events: {
      "click span.placeref": "onPlacerefClick"
      "mouseenter span.placeref": "onPlacerefEnter"
      # TODO: is this right behavior?
      # "mouseleave span.placeref": "onPlacerefLeave"
    }

    onPlacerefClick: (e) ->
      window.context = $(e.currentTarget).context
      prid = $(e.currentTarget).context.attributes.val.value
      # to MapApp.Show.Controller.onClickPlaceref
      # -> @mapView.clickPlaceref(prid)
      authid = App.request("author:model").get("author_id")
      App.vent.trigger 'placeref:click', {'id': prid, 'authorid': authid}
      # App.vent.trigger 'placeref:click', prid

    onPlacerefEnter: (e) ->
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefEnter', prid
      # App.vent.trigger('placeref:highlight', prid);

    onPlacerefLeave: (e) ->
      prid = $(e.currentTarget).context.attributes.val.value
      # console.log 'onPlaceRefLeave', id

  # passages are shown by clicking a work
  class Show.Passages extends App.Views.CompositeView
    template: "authors/show/templates/_passages"
    childView: Show.Passage
    childViewContainer: "div"
    # className: 'passages-works'

  class Show.Work extends App.Views.ItemView
    template: "authors/show/templates/_work"
    tagName: "span"
    events: {"click": "loadPassages"}
    loadPassages: ->
      work = this.model
      # show tab CHECK: leave visible?
      $("#passages_pill").removeClass("hidden")
      $(".nav-pills li").removeClass("active")
      $("#passages_pill").addClass("active")
      # use route for model attributes and navigation
      Backbone.history.navigate("workpassages/a/"+work.get('work_id'), true)

  class Show.Works extends App.Views.CompositeView
    template: "authors/show/templates/_works"
    className: 'works'
    # childView: Show.D3Thing
    childView: Show.Work
    childViewContainer: "div"
