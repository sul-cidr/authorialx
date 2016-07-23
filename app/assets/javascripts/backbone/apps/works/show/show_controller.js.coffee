@AL.module 'WorksApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  Show.Controller =

    showWork: (work) ->
      # console.log "showWork() trigger work:show for map"
      # trigger for map_app
      App.vent.trigger "work:show", work

      id = work.get("work_id")
      title = work.get("title")
      # console.log 'showAuthor: '+ id, prefname
      @workLayout = @getWorkLayout work
      # console.log '@workLayout', @workLayout

      ga('send', 'pageview', 'work_'+title);

      @workLayout.on "show", =>
        # $("#dimensions_region").addClass('hidden')
        # disable buttons, don't hide
        $(".btn").disable(true)
        @showTitle work
        @listWorkPassages work

      App.worksRegion.show @workLayout

    getWorkLayout: (work) ->
      new Show.Layout ({
        model: work
      })

    listWorkPassages: (work) ->
      id = work.get("work_id")
      title = work.get("title")
      # console.log 'Show.Controller.listWorkPassages() for',work_id
      App.request "passage:entities", id, "work", (work_passages) =>
        # wont show/render twice without reset
        if App.workContentRegion.$el.length > 0
          App.workContentRegion.reset()
        workPassagesView = @getWorkPassagesView work_passages, 'works'
        # console.log 'listWorkPassages(), '+ work_passages.length + ' for ' + id
        App.workContentRegion.show workPassagesView
        # TODO: show Passages tab if it was hidden
        $("#passages_pill").removeClass("hidden")
        # $(".passages-works h4").html('from <em>'+title+'</em')

    getWorkPassagesView: (work_passages, type) ->
      new Show.Passages ({
        collection: work_passages
        viewComparator: "passage_id"
        className: 'passages-works'
      })

    showTitle: (work) ->
      @titleView = @getTitleView work
      @workLayout.titleRegion.show @titleView

    getTitleView: (work) ->
      new Show.Title
        model: work
