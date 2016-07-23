@AL.module 'WorksApp.List', (List, App, Backbone, Marionette, $, _) ->

  List.Controller =

    startWorks: ->
      console.log 'startWorks()'
      # ensure category buttons are not disabled
      $(".btn").disable(false)
      # get, render works content
      App.request "work:entities", (works) =>
        window.works = works
        @layout = @getLayoutView()

        @layout.on "show", =>
          # AL.ContentApp.Show.Controller.showTab('works')
          @showSearchbox()
          @listCatWorks works

          $("#spin_authors").addClass('hidden')

        App.worksRegion.show @layout

    getLayoutView: ->
      new List.Layout

    showSearchbox: ->
      searchboxView = new List.Searchbox
      @layout.searchboxRegion.show searchboxView

    listCatWorks: (works) ->
      # console.log arguments.callee.caller.toString()
      window.works = works
      # console.log 'listCatWorks()', works
      worksCatView = @getCatWorksView works
      @layout.workListRegion.show worksCatView
      # for map filter
      App.vent.trigger "category:works:show", works

    getCatWorksView: (works) ->
      new List.Works
        collection: works
        # className: 'work'
